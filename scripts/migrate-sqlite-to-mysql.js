const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const mysql = require('mysql2/promise');

const SQLITE_PATH = path.join(__dirname, '..', 'database.db');
const MYSQL_DATABASE = process.env.MYSQL_DATABASE || 'daily_report';
const MYSQL_CONFIG = {
    host: process.env.MYSQL_HOST || '127.0.0.1',
    port: Number(process.env.MYSQL_PORT || 3306),
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || '',
    database: MYSQL_DATABASE,
    charset: 'utf8mb4',
    dateStrings: true
};

function openSqlite(file) {
    return new Promise((resolve, reject) => {
        const db = new sqlite3.Database(file, (err) => {
            if (err) reject(err);
            else resolve(db);
        });
    });
}

function sqliteAll(db, sql) {
    return new Promise((resolve, reject) => {
        db.all(sql, (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
        });
    });
}

async function ensureMysqlDatabase() {
    const bootstrap = await mysql.createConnection({
        host: MYSQL_CONFIG.host,
        port: MYSQL_CONFIG.port,
        user: MYSQL_CONFIG.user,
        password: MYSQL_CONFIG.password,
        charset: 'utf8mb4'
    });
    await bootstrap.query(`CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`);
    await bootstrap.end();
}

async function createTables(conn) {
    await conn.query(`
        CREATE TABLE IF NOT EXISTS workfaces (
            id VARCHAR(64) PRIMARY KEY,
            name VARCHAR(255),
            type VARCHAR(64) DEFAULT '采煤'
        )
    `);
    await conn.query(`
        CREATE TABLE IF NOT EXISTS fields (
            field_id VARCHAR(128) PRIMARY KEY,
            name VARCHAR(255),
            group_name VARCHAR(255),
            dept VARCHAR(255) DEFAULT '',
            sort_order INT DEFAULT 0
        )
    `);
    await conn.query(`
        CREATE TABLE IF NOT EXISTS users (
            id VARCHAR(36) PRIMARY KEY,
            username VARCHAR(191) UNIQUE,
            password VARCHAR(255),
            role VARCHAR(32),
            workface TEXT,
            fields TEXT,
            name VARCHAR(255)
        )
    `);
    await conn.query(`
        CREATE TABLE IF NOT EXISTS members (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(255) UNIQUE
        )
    `);
    await conn.query(`
        CREATE TABLE IF NOT EXISTS daily (
            id VARCHAR(36) PRIMARY KEY,
            date DATE,
            workface VARCHAR(64),
            suggestedRings DOUBLE NULL,
            suggestedBy TEXT,
            actualNight DOUBLE NULL,
            actualNightBy TEXT,
            actualMorning DOUBLE NULL,
            actualMorningBy TEXT,
            actualMiddle DOUBLE NULL,
            actualMiddleBy TEXT,
            jiaoyunLane TEXT,
            jiaoyunLaneBy TEXT,
            huifengLane TEXT,
            huifengLaneBy TEXT,
            deformationValue DOUBLE NULL,
            deformationValueBy TEXT,
            deformationNormalMin DOUBLE NULL,
            deformationNormalMax DOUBLE NULL,
            pressureCycle TEXT,
            pressureCycleBy TEXT,
            daysSincePressure INT NULL,
            hangingRoof DOUBLE NULL,
            hangingRoofBy TEXT,
            surfaceSettlement DOUBLE NULL,
            surfaceSettlementBy TEXT,
            conclusion TEXT,
            conclusionBy TEXT,
            remark TEXT,
            filledBy TEXT,
            createdAt DATETIME,
            status VARCHAR(32) DEFAULT 'draft',
            UNIQUE KEY unique_date_workface (date, workface)
        )
    `);
    await conn.query(`
        CREATE TABLE IF NOT EXISTS logs (
            id INT PRIMARY KEY AUTO_INCREMENT,
            username VARCHAR(191),
            action VARCHAR(64),
            table_name VARCHAR(64),
            record_id VARCHAR(64),
            field_name VARCHAR(128),
            old_value TEXT,
            new_value TEXT,
            timestamp DATETIME
        )
    `);
}

async function main() {
    await ensureMysqlDatabase();
    const sqliteDb = await openSqlite(SQLITE_PATH);
    const mysqlConn = await mysql.createConnection(MYSQL_CONFIG);

    await createTables(mysqlConn);

    const workfaces = await sqliteAll(sqliteDb, 'SELECT * FROM workfaces');
    const fields = await sqliteAll(sqliteDb, 'SELECT * FROM fields');
    const users = await sqliteAll(sqliteDb, 'SELECT * FROM users');
    const members = await sqliteAll(sqliteDb, 'SELECT * FROM members');
    const daily = await sqliteAll(sqliteDb, 'SELECT * FROM daily');
    const logs = await sqliteAll(sqliteDb, 'SELECT * FROM logs');

    await mysqlConn.query('SET FOREIGN_KEY_CHECKS = 0');
    await mysqlConn.query('TRUNCATE TABLE logs');
    await mysqlConn.query('TRUNCATE TABLE daily');
    await mysqlConn.query('TRUNCATE TABLE members');
    await mysqlConn.query('TRUNCATE TABLE users');
    await mysqlConn.query('TRUNCATE TABLE fields');
    await mysqlConn.query('TRUNCATE TABLE workfaces');
    await mysqlConn.query('SET FOREIGN_KEY_CHECKS = 1');

    for (const row of workfaces) {
        await mysqlConn.query('INSERT INTO workfaces (id, name, type) VALUES (?, ?, ?)', [row.id, row.name, row.type]);
    }
    for (const row of fields) {
        await mysqlConn.query(
            'INSERT INTO fields (field_id, name, group_name, dept, sort_order) VALUES (?, ?, ?, ?, ?)',
            [row.field_id, row.name, row.group_name, row.dept || '', row.sort_order || 0]
        );
    }
    for (const row of users) {
        await mysqlConn.query(
            'INSERT INTO users (id, username, password, role, workface, fields, name) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [row.id, row.username, row.password, row.role, row.workface, row.fields, row.name]
        );
    }
    for (const row of members) {
        await mysqlConn.query(
            'INSERT INTO members (id, name) VALUES (?, ?)',
            [row.id, row.name]
        );
    }
    for (const row of daily) {
        await mysqlConn.query(
            `INSERT INTO daily (
                id, date, workface, suggestedRings, suggestedBy, actualNight, actualNightBy,
                actualMorning, actualMorningBy, actualMiddle, actualMiddleBy, jiaoyunLane, jiaoyunLaneBy,
                huifengLane, huifengLaneBy, deformationValue, deformationValueBy, deformationNormalMin,
                deformationNormalMax, pressureCycle, pressureCycleBy, daysSincePressure, hangingRoof,
                hangingRoofBy, surfaceSettlement, surfaceSettlementBy, conclusion, conclusionBy,
                remark, filledBy, createdAt, status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                row.id, row.date, row.workface, row.suggestedRings, row.suggestedBy, row.actualNight, row.actualNightBy,
                row.actualMorning, row.actualMorningBy, row.actualMiddle, row.actualMiddleBy, row.jiaoyunLane, row.jiaoyunLaneBy,
                row.huifengLane, row.huifengLaneBy, row.deformationValue, row.deformationValueBy, row.deformationNormalMin,
                row.deformationNormalMax, row.pressureCycle, row.pressureCycleBy, row.daysSincePressure, row.hangingRoof,
                row.hangingRoofBy, row.surfaceSettlement, row.surfaceSettlementBy, row.conclusion, row.conclusionBy,
                row.remark, row.filledBy, row.createdAt, row.status
            ]
        );
    }
    for (const row of logs) {
        await mysqlConn.query(
            'INSERT INTO logs (id, username, action, table_name, record_id, field_name, old_value, new_value, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [row.id, row.username, row.action, row.table_name, row.record_id, row.field_name, row.old_value, row.new_value, row.timestamp]
        );
    }

    sqliteDb.close();
    await mysqlConn.end();
    console.log('SQLite 数据已迁移到 MySQL。');
}

main().catch((err) => {
    console.error('迁移失败:', err.message);
    process.exit(1);
});
