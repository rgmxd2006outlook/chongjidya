const express = require('express');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const mysql = require('mysql2/promise');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const PORT = 5005;
const sessions = new Map();
const MYSQL_DATABASE = process.env.MYSQL_DATABASE || 'daily_report';
const MYSQL_CONFIG = {
    host: process.env.MYSQL_HOST || '127.0.0.1',
    port: Number(process.env.MYSQL_PORT || 3306),
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || '',
    database: MYSQL_DATABASE,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    charset: 'utf8mb4',
    dateStrings: true
};
let pool;
let db;
const SQLITE_PATH = path.join(__dirname, 'database.db');
const DEFAULT_VIEW_LAYOUT = [
    {
        key: 'production',
        name: '生产组织与趋势',
        visible: true,
        sort: 1,
        groups: ['采煤'],
        fields: ['suggestedRings', 'actualMiddle', 'actualNight', 'actualMorning']
    },
    {
        key: 'position',
        name: '工作面位置',
        visible: true,
        sort: 2,
        groups: ['掘进'],
        fields: ['jiaoyunLane', 'huifengLane']
    },
    {
        key: 'deformation',
        name: '变形监测',
        visible: true,
        sort: 3,
        groups: ['掘进'],
        fields: ['deformationNormalMin', 'deformationNormalMax', 'deformationValue']
    },
    {
        key: 'pressure',
        name: '周期来压',
        visible: true,
        sort: 4,
        groups: ['掘进'],
        fields: ['pressureCycle', 'daysSincePressure']
    },
    {
        key: 'hanging',
        name: '悬顶情况',
        visible: true,
        sort: 5,
        groups: ['掘进'],
        fields: ['hangingRoof']
    },
    {
        key: 'settlement',
        name: '地表沉降',
        visible: true,
        sort: 6,
        groups: ['掘进'],
        fields: ['surfaceSettlement']
    },
    {
        key: 'remark',
        name: '备注',
        visible: true,
        sort: 7,
        groups: ['共用'],
        fields: ['remark']
    },
    {
        key: 'conclusion',
        name: '综合结论',
        visible: true,
        sort: 8,
        groups: ['掘进'],
        fields: ['conclusion']
    }
];

function isMysqlMode() {
    return Boolean(pool);
}

app.use(express.json());
app.use(express.static('public'));

// 短链接重定向
app.get('/f', (req, res) => {
    res.redirect('/fill.html');
});

app.get('/a', (req, res) => {
    res.redirect('/admin.html');
});

// 创建表结构
async function createTables() {
    await runStatement(`
        CREATE TABLE IF NOT EXISTS workfaces (
            id VARCHAR(64) PRIMARY KEY,
            name VARCHAR(255),
            type VARCHAR(64) DEFAULT '采煤',
            sort_order INT DEFAULT 0
        )
    `);

    await runStatement(`
        CREATE TABLE IF NOT EXISTS fields (
            field_id VARCHAR(128) PRIMARY KEY,
            name VARCHAR(255),
            group_name VARCHAR(255),
            dept VARCHAR(255) DEFAULT '',
            sort_order INT DEFAULT 0
        )
    `);

    await runStatement(`
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

    await runStatement(`
        CREATE TABLE IF NOT EXISTS members (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(255) UNIQUE
        )
    `);

    await runStatement(`
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
            extraData LONGTEXT,
            filledBy TEXT,
            createdAt DATETIME,
            status VARCHAR(32) DEFAULT 'draft',
            UNIQUE KEY unique_date_workface (date, workface)
        )
    `);

    await runStatement(`
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

    await runStatement(`
        CREATE TABLE IF NOT EXISTS app_settings (
            setting_key VARCHAR(128) PRIMARY KEY,
            setting_value LONGTEXT
        )
    `);
}

function createSqliteTables(callback) {
    db.run(`
        CREATE TABLE IF NOT EXISTS workfaces (
            id TEXT PRIMARY KEY,
            name TEXT,
            type TEXT DEFAULT '采煤',
            sort_order INTEGER DEFAULT 0
        )
    `, () => {
        db.run(`
            CREATE TABLE IF NOT EXISTS fields (
                field_id TEXT PRIMARY KEY,
                name TEXT,
                group_name TEXT,
                dept TEXT DEFAULT '',
                sort_order INTEGER DEFAULT 0
            )
        `, () => {
            db.run(`
                CREATE TABLE IF NOT EXISTS users (
                    id TEXT PRIMARY KEY,
                    username TEXT UNIQUE,
                    password TEXT,
                    role TEXT,
                    workface TEXT,
                    fields TEXT,
                    name TEXT
                )
            `, () => {
                db.run(`
                    CREATE TABLE IF NOT EXISTS members (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT UNIQUE
                    )
                `, () => {
                    db.run(`
                        CREATE TABLE IF NOT EXISTS daily (
                            id TEXT PRIMARY KEY,
                            date TEXT,
                            workface TEXT,
                            suggestedRings REAL,
                            suggestedBy TEXT,
                            actualNight REAL,
                            actualNightBy TEXT,
                            actualMorning REAL,
                            actualMorningBy TEXT,
                            actualMiddle REAL,
                            actualMiddleBy TEXT,
                            jiaoyunLane TEXT,
                            jiaoyunLaneBy TEXT,
                            huifengLane TEXT,
                            huifengLaneBy TEXT,
                            deformationValue REAL,
                            deformationValueBy TEXT,
                            deformationNormalMin REAL,
                            deformationNormalMax REAL,
                            pressureCycle TEXT,
                            pressureCycleBy TEXT,
                            daysSincePressure INTEGER,
                            hangingRoof REAL,
                            hangingRoofBy TEXT,
                            surfaceSettlement REAL,
                            surfaceSettlementBy TEXT,
                            conclusion TEXT,
                            conclusionBy TEXT,
                            remark TEXT,
                            extraData TEXT,
                            filledBy TEXT,
                            createdAt TEXT,
                            status TEXT DEFAULT 'draft',
                            UNIQUE(date, workface)
                        )
                    `, () => {
                        db.run(`
                            CREATE TABLE IF NOT EXISTS logs (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                username TEXT,
                                action TEXT,
                                table_name TEXT,
                                record_id TEXT,
                                field_name TEXT,
                                old_value TEXT,
                                new_value TEXT,
                                timestamp TEXT
                            )
                        `, () => {
                            db.run(`
                                CREATE TABLE IF NOT EXISTS app_settings (
                                    setting_key TEXT PRIMARY KEY,
                                    setting_value TEXT
                                )
                            `, () => {
                                db.run(`ALTER TABLE fields ADD COLUMN dept TEXT DEFAULT ''`, () => {
                                    db.run(`ALTER TABLE daily ADD COLUMN extraData TEXT`, () => {
                                        db.run(`ALTER TABLE workfaces ADD COLUMN sort_order INTEGER DEFAULT 0`, () => {
                                            callback();
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });
    });
}

// 插入默认数据
function insertDefaultData() {
    // 默认工作面
    db.run(
        `${isMysqlMode() ? 'INSERT IGNORE' : 'INSERT OR IGNORE'} INTO workfaces (id, name, type, sort_order) VALUES (?, ?, ?, ?), (?, ?, ?, ?)`,
        ['30210', '30210工作面', '采煤', 1, '30102', '30102工作面', '采煤', 2]
    );
    
    // 默认栏目配置（带排序编号）
    const defaultFields = [
        { id: 'suggestedRings', name: '建议刀数', group: '采煤', sort: 1 },
        { id: 'actualMiddle', name: '中班刀数', group: '采煤', sort: 2 },
        { id: 'actualNight', name: '夜班刀数', group: '采煤', sort: 3 },
        { id: 'actualMorning', name: '早班刀数', group: '采煤', sort: 4 },
        { id: 'jiaoyunLane', name: '胶运巷位置', group: '掘进', sort: 5 },
        { id: 'huifengLane', name: '回风巷位置', group: '掘进', sort: 6 },
        { id: 'deformationValue', name: '变形监测', group: '掘进', sort: 7 },
        { id: 'pressureCycle', name: '周期来压', group: '掘进', sort: 8 },
        { id: 'hangingRoof', name: '悬顶情况', group: '掘进', sort: 9 },
        { id: 'surfaceSettlement', name: '沉降情况', group: '掘进', sort: 10 },
        { id: 'conclusion', name: '综合结论', group: '掘进', sort: 11 }
    ];
    
    for (const field of defaultFields) {
        db.run(`${isMysqlMode() ? 'INSERT IGNORE' : 'INSERT OR IGNORE'} INTO fields (field_id, name, group_name, dept, sort_order) VALUES (?, ?, ?, ?, ?)`, 
            [field.id, field.name, field.group, DEFAULT_FIELDS[field.id]?.dept || '', field.sort]);
    }
    
    // 允许彻底删除历史遗留默认字段，重启后不再自动补回
    db.run(`DELETE FROM fields WHERE field_id IN (?, ?)`, ['dailyMaxRings', 'shiftMaxRings'], () => {});

    // 默认管理员用户
    db.run(`${isMysqlMode() ? 'INSERT IGNORE' : 'INSERT OR IGNORE'} INTO users (id, username, password, role, workface, fields, name) VALUES (?, ?, ?, ?, ?, ?, ?)`, 
        [uuidv4(), 'admin', '102184', 'admin', '30210,30102', 'suggestedRings,actualNight,actualMorning,actualMiddle,jiaoyunLane,huifengLane,deformationValue,pressureCycle,hangingRoof,surfaceSettlement,conclusion', '管理员']);

    db.run(
        `${isMysqlMode() ? 'INSERT IGNORE' : 'INSERT OR IGNORE'} INTO app_settings (setting_key, setting_value) VALUES (?, ?)`,
        ['viewLayout', JSON.stringify(DEFAULT_VIEW_LAYOUT)]
    );
}

// 工作面配置
const DEFAULT_WORKFACES = [
    { id: '30210', name: '30210工作面' },
    { id: '30102', name: '30102工作面' }
];

// 加载工作面列表
function loadWorkfaces(callback) {
    db.all('SELECT * FROM workfaces ORDER BY sort_order ASC, id ASC', (err, rows) => {
        if (err) {
            console.error('Error loading workfaces:', err.message);
            callback([]);
        } else {
            callback(rows);
        }
    });
}

// 保存工作面列表
function saveWorkface(id, name, type, sortOrder, callback) {
    const sql = isMysqlMode()
        ? `INSERT INTO workfaces (id, name, type, sort_order) VALUES (?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE name = VALUES(name), type = VALUES(type), sort_order = VALUES(sort_order)`
        : 'INSERT OR REPLACE INTO workfaces (id, name, type, sort_order) VALUES (?, ?, ?, ?)';
    db.run(sql, [id, name, type, sortOrder], function(err) {
        if (err) {
            console.error('Error saving workface:', err.message);
            callback(false, err.message);
        } else {
            callback(true);
        }
    });
}

// 删除工作面
function deleteWorkface(id, callback) {
    db.run('DELETE FROM workfaces WHERE id = ?', [id], (err) => {
        if (err) {
            console.error('Error deleting workface:', err.message);
            callback(false);
        } else {
            callback(true);
        }
    });
}

// 栏目配置（默认值）
const DEFAULT_FIELDS = {
    suggestedRings: { name: '建议刀数', group: '生产组织', dept: '监测员' },
    actualNight: { name: '夜班刀数', group: '实际刀数', dept: '综采队' },
    actualMorning: { name: '早班刀数', group: '实际刀数', dept: '综采队' },
    actualMiddle: { name: '中班刀数', group: '实际刀数', dept: '综采队' },
    jiaoyunLane: { name: '胶运巷位置', group: '工作面位置', dept: '综采队' },
    huifengLane: { name: '回风巷位置', group: '工作面位置', dept: '综采队' },
    deformationValue: { name: '变形监测', group: '变形监测', dept: '监测员' },
    pressureCycle: { name: '周期来压', group: '周期来压', dept: '防冲管理部' },
    hangingRoof: { name: '悬顶情况', group: '悬顶情况', dept: '综采队' },
    surfaceSettlement: { name: '沉降情况', group: '地表沉降', dept: '地测部' },
    conclusion: { name: '综合结论', group: '综合结论', dept: '防冲管理部' }
};

// 加载栏目配置
function loadFields(callback) {
    db.all('SELECT * FROM fields ORDER BY sort_order ASC, field_id ASC', (err, rows) => {
        if (err) {
            console.error('Error loading fields:', err.message);
            callback({});
        } else {
            const fields = {};
            rows.forEach(row => {
                fields[row.field_id] = { name: row.name, group: row.group_name, dept: row.dept || '', sort: row.sort_order };
            });
            callback(fields);
        }
    });
}

// 保存栏目配置
function saveField(fieldId, name, group, dept, sortOrder, callback) {
    const sql = isMysqlMode()
        ? `INSERT INTO fields (field_id, name, group_name, dept, sort_order) VALUES (?, ?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE
               name = VALUES(name),
               group_name = VALUES(group_name),
               dept = VALUES(dept),
               sort_order = VALUES(sort_order)`
        : 'INSERT OR REPLACE INTO fields (field_id, name, group_name, dept, sort_order) VALUES (?, ?, ?, ?, ?)';
    db.run(sql, 
        [fieldId, name, group, dept || '', sortOrder], function(err) {
            if (err) {
                console.error('Error saving field:', err.message);
                callback(false);
            } else {
                callback(true);
            }
        });
}

// 删除栏目
function deleteField(fieldId, callback) {
    db.run('DELETE FROM fields WHERE field_id = ?', [fieldId], (err) => {
        if (err) {
            console.error('Error deleting field:', err.message);
            callback(false);
        } else {
            callback(true);
        }
    });
}

function normalizeViewLayoutConfig(config) {
    const rawList = Array.isArray(config) ? config : [];
    const incomingMap = new Map(
        rawList
            .filter(item => item && String(item.key || '').trim())
            .map(item => [String(item.key).trim(), item])
    );
    const defaultKeys = new Set(DEFAULT_VIEW_LAYOUT.map(item => item.key));
    const normalizeList = (value, fallback) => {
        const source = Array.isArray(value) ? value : fallback;
        const normalized = source
            .map(item => String(item || '').trim())
            .filter(Boolean);
        return Array.from(new Set(normalized));
    };
    const normalizedDefaults = DEFAULT_VIEW_LAYOUT.map((item) => {
        const custom = incomingMap.get(item.key) || {};
        return {
            key: item.key,
            name: String(custom.name || item.name),
            visible: typeof custom.visible === 'boolean' ? custom.visible : item.visible,
            sort: Number.isFinite(Number(custom.sort)) ? Number(custom.sort) : item.sort,
            groups: normalizeList(custom.groups, item.groups || []),
            fields: normalizeList(custom.fields, item.fields || [])
        };
    });
    const normalizedCustoms = rawList
        .filter(item => item && !defaultKeys.has(String(item.key || '').trim()))
        .map(item => {
            const key = String(item.key || '').trim();
            if (!key) return null;
            return {
                key,
                name: String(item.name || key),
                visible: typeof item.visible === 'boolean' ? item.visible : true,
                sort: Number.isFinite(Number(item.sort)) ? Number(item.sort) : 999,
                groups: normalizeList(item.groups, ['共用']),
                fields: normalizeList(item.fields, [])
            };
        })
        .filter(Boolean);

    return [...normalizedDefaults, ...normalizedCustoms].sort((a, b) => a.sort - b.sort);
}

function getViewLayoutConfig(callback) {
    db.get('SELECT setting_value FROM app_settings WHERE setting_key = ?', ['viewLayout'], (err, row) => {
        if (err) {
            console.error('Error loading view layout:', err.message);
            callback(DEFAULT_VIEW_LAYOUT);
            return;
        }

        try {
            const parsed = row?.setting_value ? JSON.parse(row.setting_value) : DEFAULT_VIEW_LAYOUT;
            callback(normalizeViewLayoutConfig(parsed));
        } catch (error) {
            console.error('Error parsing view layout:', error.message);
            callback(DEFAULT_VIEW_LAYOUT);
        }
    });
}

function saveViewLayoutConfig(config, callback) {
    const normalized = normalizeViewLayoutConfig(config);
    const sql = isMysqlMode()
        ? `INSERT INTO app_settings (setting_key, setting_value) VALUES (?, ?)
           ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)`
        : 'INSERT OR REPLACE INTO app_settings (setting_key, setting_value) VALUES (?, ?)';

    db.run(sql, ['viewLayout', JSON.stringify(normalized)], (err) => {
        if (err) {
            console.error('Error saving view layout:', err.message);
            callback(false, normalized);
            return;
        }
        callback(true, normalized);
    });
}

// 工具函数
async function runStatement(sql, params = []) {
    const [result] = await pool.query(sql, params);
    return result;
}

function createDbAdapter(mysqlPool) {
    return {
        run(sql, params, callback) {
            const safeParams = Array.isArray(params) ? params : [];
            const safeCallback = typeof params === 'function'
                ? params
                : (typeof callback === 'function' ? callback : () => {});
            mysqlPool.query(sql, safeParams)
                .then(([result]) => {
                    safeCallback.call({ lastID: result.insertId, changes: result.affectedRows }, null);
                })
                .catch((err) => {
                    safeCallback.call({}, err);
                });
        },
        all(sql, params, callback) {
            const safeParams = Array.isArray(params) ? params : [];
            const safeCallback = typeof params === 'function'
                ? params
                : (typeof callback === 'function' ? callback : () => {});
            mysqlPool.query(sql, safeParams)
                .then(([rows]) => safeCallback(null, rows))
                .catch((err) => safeCallback(err, []));
        },
        get(sql, params, callback) {
            const safeParams = Array.isArray(params) ? params : [];
            const safeCallback = typeof params === 'function'
                ? params
                : (typeof callback === 'function' ? callback : () => {});
            mysqlPool.query(sql, safeParams)
                .then(([rows]) => safeCallback(null, rows[0] || null))
                .catch((err) => safeCallback(err, null));
        }
    };
}

async function initDatabase() {
    try {
        const bootstrapConfig = {
            host: MYSQL_CONFIG.host,
            port: MYSQL_CONFIG.port,
            user: MYSQL_CONFIG.user,
            password: MYSQL_CONFIG.password,
            charset: 'utf8mb4'
        };
        const bootstrap = await mysql.createConnection(bootstrapConfig);
        await bootstrap.query(`CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`);
        await bootstrap.end();

        pool = mysql.createPool(MYSQL_CONFIG);
        db = createDbAdapter(pool);
        console.log('Connected to the MySQL database.');
        await createTables();
        try {
            await runStatement('ALTER TABLE daily ADD COLUMN extraData LONGTEXT');
        } catch (migrationErr) {
            // Ignore duplicate-column errors in existing databases.
        }
        try {
            await runStatement('ALTER TABLE workfaces ADD COLUMN sort_order INT DEFAULT 0');
        } catch (migrationErr) {
            // Ignore duplicate-column errors in existing databases.
        }
        insertDefaultData();
    } catch (err) {
        console.warn(`MySQL 不可用，已回退到 SQLite: ${err.message}`);
        await new Promise((resolve, reject) => {
            const sqliteDb = new sqlite3.Database(SQLITE_PATH, (openErr) => {
                if (openErr) {
                    reject(openErr);
                    return;
                }
                db = sqliteDb;
                createSqliteTables(() => {
                    insertDefaultData();
                    resolve();
                });
            });
        });
    }
}

// 数据库操作工具函数
function runQuery(sql, params, callback) {
    db.run(sql, params, function(err) {
        if (err) {
            console.error('Error running query:', err.message);
            callback(false);
        } else {
            callback(true);
        }
    });
}

function getQuery(sql, params, callback) {
    db.all(sql, params, (err, rows) => {
        if (err) {
            console.error('Error getting query:', err.message);
            callback([]);
        } else {
            callback(rows);
        }
    });
}

function getSingleQuery(sql, params, callback) {
    db.get(sql, params, (err, row) => {
        if (err) {
            console.error('Error getting single query:', err.message);
            callback(null);
        } else {
            callback(row);
        }
    });
}

function attachDailyAliases(row) {
    if (!row) return row;
    let extraData = {};
    if (row.extraData) {
        try {
            const parsed = typeof row.extraData === 'string' ? JSON.parse(row.extraData) : row.extraData;
            if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
                extraData = parsed;
            }
        } catch (err) {
            extraData = {};
        }
    }
    return {
        ...row,
        ...extraData,
        dailyMaxRings: row.dailyMaxRings ?? row.suggestedRings ?? 0
    };
}

const DAILY_STANDARD_FIELDS = new Set([
    'id', 'date', 'workface', 'dailyMaxRings',
    'suggestedRings', 'suggestedBy',
    'actualNight', 'actualNightBy',
    'actualMorning', 'actualMorningBy',
    'actualMiddle', 'actualMiddleBy',
    'jiaoyunLane', 'jiaoyunLaneBy',
    'huifengLane', 'huifengLaneBy',
    'deformationValue', 'deformationValueBy',
    'deformationNormalMin', 'deformationNormalMax',
    'pressureCycle', 'pressureCycleBy',
    'daysSincePressure',
    'hangingRoof', 'hangingRoofBy',
    'surfaceSettlement', 'surfaceSettlementBy',
    'conclusion', 'conclusionBy',
    'remark', 'filledBy', 'createdAt', 'status',
    'token', '_auth', 'extraData'
]);

function extractCustomDailyFields(body) {
    const result = {};
    Object.entries(body || {}).forEach(([key, value]) => {
        if (DAILY_STANDARD_FIELDS.has(key)) return;
        if (!key || key.startsWith('_')) return;
        result[key] = value === undefined || value === null ? '' : String(value);
    });
    return result;
}

function parseNullableNumber(value) {
    if (value === '' || value === null || value === undefined) {
        return null;
    }
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
}

function parseNullableInteger(value) {
    if (value === '' || value === null || value === undefined) {
        return null;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) ? parsed : null;
}

function extractToken(req) {
    const header = req.headers.authorization || '';
    if (header.startsWith('Bearer ')) {
        return header.slice(7);
    }
    return req.headers['x-auth-token'] || req.body?.token || req.body?._auth?.token || req.query?.token || '';
}

function getAuthUser(req) {
    const token = extractToken(req);
    if (!token) return null;
    return sessions.get(token) || null;
}

function requireAuth(req, res, next) {
    const user = getAuthUser(req);
    if (!user) {
        return res.status(401).json({ error: '请先登录' });
    }
    req.authUser = user;
    next();
}

function requireAdmin(req, res, next) {
    const user = getAuthUser(req);
    if (!user || user.role !== 'admin') {
        return res.status(403).json({ error: '需要管理员权限' });
    }
    req.authUser = user;
    next();
}

// 日志记录函数
function logOperation(username, action, table_name, record_id, field_name, old_value, new_value) {
    const timestamp = new Date().toISOString().replace('T', ' ').slice(0, 19);
    db.run(
        'INSERT INTO logs (username, action, table_name, record_id, field_name, old_value, new_value, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [username, action, table_name, record_id, field_name, old_value, new_value, timestamp],
        (err) => {
            if (err) {
                console.error('Error logging operation:', err.message);
            }
        }
    );
}

// 获取栏目配置
app.get('/api/fields', (req, res) => {
    loadFields((fields) => {
        res.json(fields);
    });
});

// 添加栏目
app.post('/api/fields', requireAdmin, (req, res) => {
    const { fieldId, name, group, dept, sort } = req.body;
    if (!fieldId || !name) {
        return res.status(400).json({ error: '字段ID和名称不能为空' });
    }
    
    // 检查字段是否已存在
    getSingleQuery('SELECT * FROM fields WHERE field_id = ?', [fieldId], (row) => {
        if (row) {
            return res.status(400).json({ error: '字段ID已存在' });
        }
        
        // 获取最大排序号
        getSingleQuery('SELECT MAX(sort_order) as max_sort FROM fields', [], (result) => {
            const maxSort = result && result.max_sort ? result.max_sort : 0;
            const newSort = sort || (maxSort + 1);
            
            // 保存新字段
            saveField(fieldId, name, group || '', dept || '', newSort, (success) => {
                if (success) {
                    loadFields((fields) => {
                        res.json({ success: true, fields });
                    });
                } else {
                    res.status(500).json({ error: '保存失败' });
                }
            });
        });
    });
});

// 更新栏目
app.put('/api/fields/:fieldId', requireAdmin, (req, res) => {
    const { fieldId } = req.params;
    const { name, group, dept, sort } = req.body;
    
    // 检查字段是否存在
    getSingleQuery('SELECT * FROM fields WHERE field_id = ?', [fieldId], (row) => {
        if (!row) {
            return res.status(404).json({ error: '栏目不存在' });
        }
        
        // 更新字段
        const sortOrder = sort !== undefined ? sort : (row.sort_order || 0);
        saveField(fieldId, name, group || '', dept ?? row.dept ?? '', sortOrder, (success) => {
            if (success) {
                loadFields((fields) => {
                    res.json({ success: true, fields });
                });
            } else {
                res.status(500).json({ error: '更新失败' });
            }
        });
    });
});

// 删除栏目
app.delete('/api/fields/:fieldId', requireAdmin, (req, res) => {
    const { fieldId } = req.params;
    
    // 检查字段是否存在
    getSingleQuery('SELECT * FROM fields WHERE field_id = ?', [fieldId], (row) => {
        if (!row) {
            return res.status(404).json({ error: '栏目不存在' });
        }
        
        // 删除字段
        deleteField(fieldId, (success) => {
            if (success) {
                loadFields((fields) => {
                    res.json({ success: true, fields });
                });
            } else {
                res.status(500).json({ error: '删除失败' });
            }
        });
    });
});

app.get('/api/view-layout', (req, res) => {
    getViewLayoutConfig((config) => {
        res.json(config);
    });
});

app.put('/api/view-layout', requireAdmin, (req, res) => {
    const config = Array.isArray(req.body) ? req.body : req.body?.config;
    if (!Array.isArray(config)) {
        return res.status(400).json({ error: '配置格式不正确' });
    }

    saveViewLayoutConfig(config, (success, normalized) => {
        if (success) {
            res.json({ success: true, config: normalized });
        } else {
            res.status(500).json({ error: '保存失败' });
        }
    });
});

// ===== 工作面管理 API =====
app.get('/api/workfaces', (req, res) => {
    loadWorkfaces((workfaces) => {
        res.json(workfaces);
    });
});

app.post('/api/workfaces', requireAdmin, (req, res) => {
    const { id, name, type, sort } = req.body;
    if (!id || !name) {
        return res.status(400).json({ error: '工作面ID和名称不能为空' });
    }
    
    // 检查工作面是否已存在
    getSingleQuery('SELECT * FROM workfaces WHERE id = ?', [id], (row) => {
        if (row) {
            return res.status(400).json({ error: '工作面ID已存在' });
        }
        
        getSingleQuery('SELECT MAX(sort_order) AS max_sort FROM workfaces', [], (sortRow) => {
            const sortOrder = Number.isFinite(Number(sort))
                ? Number(sort)
                : (Number(sortRow?.max_sort) || 0) + 1;
            // 保存新工作面
            saveWorkface(id, name, type || '采煤', sortOrder, (success, errorMsg) => {
                if (success) {
                    loadWorkfaces((workfaces) => {
                        res.json({ success: true, workfaces });
                    });
                } else {
                    res.status(500).json({ error: '保存失败: ' + (errorMsg || '未知错误') });
                }
            });
        });
    });
});

app.put('/api/workfaces/:id', requireAdmin, (req, res) => {
    const { id } = req.params;
    const { name, type, sort } = req.body;
    
    // 检查工作面是否存在
    getSingleQuery('SELECT * FROM workfaces WHERE id = ?', [id], (row) => {
        if (!row) {
            return res.status(404).json({ error: '工作面不存在' });
        }
        
        // 更新工作面
        const sortOrder = Number.isFinite(Number(sort)) ? Number(sort) : (Number(row.sort_order) || 0);
        saveWorkface(id, name, type || row.type || '采煤', sortOrder, (success) => {
            if (success) {
                loadWorkfaces((workfaces) => {
                    res.json({ success: true, workfaces });
                });
            } else {
                res.status(500).json({ error: '更新失败' });
            }
        });
    });
});

app.delete('/api/workfaces/:id', requireAdmin, (req, res) => {
    const { id } = req.params;
    
    // 检查工作面是否存在
    getSingleQuery('SELECT * FROM workfaces WHERE id = ?', [id], (row) => {
        if (!row) {
            return res.status(404).json({ error: '工作面不存在' });
        }
        
        // 删除工作面
        deleteWorkface(id, (success) => {
            if (success) {
                loadWorkfaces((workfaces) => {
                    res.json({ success: true, workfaces });
                });
            } else {
                res.status(500).json({ error: '删除失败' });
            }
        });
    });
});

// ===== 用户管理 API =====
app.get('/api/users', (req, res) => {
    const authUser = getAuthUser(req);
    if (!authUser || authUser.role !== 'admin') {
        return res.status(403).json({ error: '需要管理员权限' });
    }

    getQuery('SELECT id, username, role, workface, fields, name FROM users', [], (rows) => {
        // 处理 fields 字段
        const users = rows.map(u => {
            let fields = u.fields || '';
            if (typeof fields === 'string') {
                fields = fields.split(',').filter(f => f);
            }
            return { id: u.id, username: u.username, role: u.role, workface: u.workface, fields, name: u.name };
        });
        res.json(users);
    });
});

app.post('/api/users/login', (req, res) => {
    const { username, password } = req.body;
    
    getSingleQuery('SELECT * FROM users WHERE username = ? AND password = ?', [username, password], (user) => {
        if (user) {
            const token = uuidv4();
            sessions.set(token, { id: user.id, username: user.username, role: user.role, workface: user.workface, name: user.name });
            // 处理 fields 字段（可能是字符串或数组）
            let fields = user.fields || '';
            if (typeof fields === 'string') {
                fields = fields.split(',').filter(f => f);
            }
            
            res.json({ 
                success: true, 
                token,
                user: { id: user.id, username: user.username, role: user.role, workface: user.workface, name: user.name, fields: fields }
            });
        } else {
            res.status(401).json({ error: '用户名或密码错误' });
        }
    });
});

app.post('/api/users', requireAdmin, (req, res) => {
    console.log('Received create user request:', JSON.stringify(req.body));
    let { username, password, role, workface, name, fields } = req.body;
    
    // 确保fields字段是正确的格式
    if (fields) {
        if (Array.isArray(fields)) {
            fields = fields.join(',');
        } else if (typeof fields === 'object' && fields !== null) {
            fields = '';
        }
    } else {
        fields = '';
    }
    
    console.log('Processed fields:', fields);
    console.log('Fields type:', typeof fields);
    
    if (!username || !password) {
        return res.status(400).json({ error: '用户名和密码不能为空' });
    }
    
    // 检查用户名是否已存在
    getSingleQuery('SELECT * FROM users WHERE username = ?', [username], (row) => {
        if (row) {
            return res.status(400).json({ error: '用户名已存在' });
        }
        
        // 直接使用字符串作为fields值，确保它是字符串格式
        let fieldsValue = '';
        if (Array.isArray(fields)) {
            fieldsValue = fields.join(',');
        } else if (typeof fields === 'object' && fields !== null) {
            fieldsValue = '';
        } else {
            fieldsValue = fields || '';
        }
        console.log('Final fields value to insert:', fieldsValue);
        
        const user = {
            id: uuidv4(),
            username,
            password,  // 简单存储，生产环境应该加密
            role: role || 'user',  // admin 或 user
            workface: workface || '',  // 可以填写的工作面
            fields: fieldsValue,
            name: name || username
        };
        console.log('User object:', user);
        
        console.log('Insert params:', [user.id, user.username, user.password, user.role, user.workface, user.fields, user.name]);
        
        // 直接使用字符串作为fields值，确保它是字符串格式
        runQuery('INSERT INTO users (id, username, password, role, workface, fields, name) VALUES (?, ?, ?, ?, ?, ?, ?)', 
            [user.id, user.username, user.password, user.role, user.workface, fieldsValue, user.name], (success) => {
                if (success) {
                    // 重新获取用户信息，确保返回的是数据库中的实际值
                    getSingleQuery('SELECT * FROM users WHERE id = ?', [user.id], (newUser) => {
                        // 处理fields字段，确保返回数组格式
                        let userFields = newUser.fields || '';
                        if (typeof userFields === 'string') {
                            userFields = userFields.split(',').filter(f => f);
                        }
                        res.json({ success: true, user: { id: newUser.id, username: newUser.username, role: newUser.role, workface: newUser.workface, fields: userFields, name: newUser.name } });
                    });
                } else {
                    res.status(500).json({ error: '保存失败' });
                }
            });
    });
});

// 更新用户
app.put('/api/users/:id', requireAdmin, (req, res) => {
    console.log('Received update user request:', req.body);
    console.log('Fields:', req.body.fields);
    console.log('Fields type:', typeof req.body.fields);
    console.log('Is array:', Array.isArray(req.body.fields));
    console.log('Is object:', typeof req.body.fields === 'object' && req.body.fields !== null);
    const { id } = req.params;
    const { password, role, fields, workface, name } = req.body;
    
    // 检查用户是否存在
    getSingleQuery('SELECT * FROM users WHERE id = ?', [id], (user) => {
        if (!user) {
            return res.status(404).json({ error: '用户不存在' });
        }
        
        // 构建更新语句
        let updates = [];
        let params = [];
        
        if (password) {
            updates.push('password = ?');
            params.push(password);
        }
        if (role) {
            updates.push('role = ?');
            params.push(role);
        }
        if (fields !== undefined && fields !== null) {
            updates.push('fields = ?');
            // 强制处理fields字段，确保它是字符串格式
            let processedFields = '';
            if (Array.isArray(fields)) {
                processedFields = fields.join(',');
            } else if (typeof fields === 'object' && fields !== null) {
                // 处理可能的对象格式
                processedFields = '';
            } else if (typeof fields === 'string') {
                processedFields = fields;
            }
            params.push(processedFields);
        }
        if (workface !== undefined) {
            updates.push('workface = ?');
            params.push(workface);
        }
        if (name) {
            updates.push('name = ?');
            params.push(name);
        }
        
        if (updates.length === 0) {
            return res.json({ success: true, user });
        }
        
        params.push(id);
        const sql = `UPDATE users SET ${updates.join(', ')} WHERE id = ?`;
        
        runQuery(sql, params, (success) => {
            if (success) {
                // 获取更新后的用户
                getSingleQuery('SELECT * FROM users WHERE id = ?', [id], (updatedUser) => {
                    // 处理fields字段，确保返回数组格式
                    let userFields = updatedUser.fields || '';
                    if (typeof userFields === 'string') {
                        userFields = userFields.split(',').filter(f => f);
                    } else if (typeof userFields === 'object' && userFields !== null) {
                        userFields = [];
                    }
                    updatedUser.fields = userFields;
                    res.json({ success: true, user: updatedUser });
                });
            } else {
                res.status(500).json({ error: '更新失败' });
            }
        });
    });
});

app.delete('/api/users/:id', requireAdmin, (req, res) => {
    const { id } = req.params;
    
    // 检查用户是否存在
    getSingleQuery('SELECT * FROM users WHERE id = ?', [id], (user) => {
        if (!user) {
            return res.status(404).json({ error: '用户不存在' });
        }
        
        // 删除用户
        runQuery('DELETE FROM users WHERE id = ?', [id], (success) => {
            if (success) {
                res.json({ success: true });
            } else {
                res.status(500).json({ error: '删除失败' });
            }
        });
    });
});

// ===== 人员管理 API =====
app.get('/api/members', (req, res) => {
    getQuery('SELECT name FROM members', [], (rows) => {
        const members = rows.map(row => row.name);
        res.json(members);
    });
});

app.post('/api/members', requireAdmin, (req, res) => {
    const name = req.body.name?.trim();
    
    if (!name) return res.status(400).json({ error: '姓名不能为空' });
    
    // 检查人员是否已存在
    getSingleQuery('SELECT * FROM members WHERE name = ?', [name], (row) => {
        if (row) return res.status(400).json({ error: '该人员已存在' });
        
        // 保存新人员
        runQuery('INSERT INTO members (name) VALUES (?)', [name], (success) => {
            if (success) {
                res.json({ success: true, name });
            } else {
                res.status(500).json({ error: '保存失败' });
            }
        });
    });
});

app.delete('/api/members/:name', requireAdmin, (req, res) => {
    const name = decodeURIComponent(req.params.name);
    
    // 检查人员是否存在
    getSingleQuery('SELECT * FROM members WHERE name = ?', [name], (row) => {
        if (!row) return res.status(404).json({ error: '人员不存在' });
        
        // 删除人员
        runQuery('DELETE FROM members WHERE name = ?', [name], (success) => {
            if (success) {
                res.json({ success: true });
            } else {
                res.status(500).json({ error: '删除失败' });
            }
        });
    });
});

// ===== 每日综合数据 API =====

// 获取所有每日数据（展示页面用，公开）
app.get('/api/daily', (req, res) => {
    getQuery('SELECT * FROM daily ORDER BY date DESC', [], (rows) => {
        res.json(rows.map(attachDailyAliases));
    });
});

// 获取某天数据
app.get('/api/daily/:date', (req, res) => {
    getQuery('SELECT * FROM daily WHERE date = ?', [req.params.date], (rows) => {
        res.json((rows || []).map(attachDailyAliases));
    });
});

// 保存每日数据（需要登录）
app.post('/api/daily', requireAuth, (req, res) => {
    const { username, role, workface: authWorkface } = req.authUser;
    const requestedWorkface = req.body.workface || '30210';
    const allowedWorkfaces = String(authWorkface || '').split(',').filter(Boolean);

    if (role !== 'admin' && allowedWorkfaces.length > 0 && !allowedWorkfaces.includes(requestedWorkface)) {
        return res.status(403).json({ error: '无权填写该工作面' });
    }
    
    const item = {
        id: uuidv4(),
        date: req.body.date || new Date().toISOString().split('T')[0],
        workface: requestedWorkface,
        
        // 生产组织
        suggestedRings: parseNullableNumber(req.body.suggestedRings ?? req.body.dailyMaxRings),
        suggestedBy: req.body.suggestedBy || '',  // 建议刀数填写人
        
        // 实际刀数（按班次）
        actualNight: parseNullableNumber(req.body.actualNight),
        actualNightBy: req.body.actualNightBy || '',
        actualMorning: parseNullableNumber(req.body.actualMorning),
        actualMorningBy: req.body.actualMorningBy || '',
        actualMiddle: parseNullableNumber(req.body.actualMiddle),
        actualMiddleBy: req.body.actualMiddleBy || '',
        
        // 工作面位置
        jiaoyunLane: req.body.jiaoyunLane || '',
        jiaoyunLaneBy: req.body.jiaoyunLaneBy || '',
        huifengLane: req.body.huifengLane || '',
        huifengLaneBy: req.body.huifengLaneBy || '',
        
        // 变形监测
        deformationValue: parseNullableNumber(req.body.deformationValue),
        deformationValueBy: req.body.deformationValueBy || '',
        deformationNormalMin: parseNullableNumber(req.body.deformationNormalMin),
        deformationNormalMax: parseNullableNumber(req.body.deformationNormalMax),
        
        // 周期来压
        pressureCycle: req.body.pressureCycle || '',
        pressureCycleBy: req.body.pressureCycleBy || '',
        daysSincePressure: parseNullableInteger(req.body.daysSincePressure),
        
        // 悬顶情况
        hangingRoof: parseNullableNumber(req.body.hangingRoof),
        hangingRoofBy: req.body.hangingRoofBy || '',
        
        // 地表沉降
        surfaceSettlement: parseNullableNumber(req.body.surfaceSettlement),
        surfaceSettlementBy: req.body.surfaceSettlementBy || '',
        
        // 综合研判结论
        conclusion: req.body.conclusion || '',
        conclusionBy: req.body.conclusionBy || '',
        
        // 备注
        remark: req.body.remark || '',
        
        filledBy: username || '',  // 最后修改人
        
        createdAt: new Date().toISOString().replace('T', ' ').slice(0, 19),
        status: 'completed'  // 数据填写完成后设置为已完成状态
    };
    const incomingCustomFields = extractCustomDailyFields(req.body);
    
    // 检查是否已存在（同一天+同一工作面）
    getSingleQuery('SELECT * FROM daily WHERE date = ? AND workface = ?', [item.date, item.workface], (existing) => {
        if (existing) {
            // 更新现有数据
            let updates = [];
            let params = [];
            const hasField = (key) => Object.prototype.hasOwnProperty.call(req.body, key);
            const hasSuggested = hasField('suggestedRings') || hasField('dailyMaxRings');
            
            // 记录字段变更
            const fieldsToUpdate = {};
            if (hasSuggested) fieldsToUpdate.suggestedRings = item.suggestedRings;
            if (hasField('suggestedBy')) fieldsToUpdate.suggestedBy = item.suggestedBy;
            if (hasField('actualNight')) fieldsToUpdate.actualNight = item.actualNight;
            if (hasField('actualNightBy')) fieldsToUpdate.actualNightBy = item.actualNightBy;
            if (hasField('actualMorning')) fieldsToUpdate.actualMorning = item.actualMorning;
            if (hasField('actualMorningBy')) fieldsToUpdate.actualMorningBy = item.actualMorningBy;
            if (hasField('actualMiddle')) fieldsToUpdate.actualMiddle = item.actualMiddle;
            if (hasField('actualMiddleBy')) fieldsToUpdate.actualMiddleBy = item.actualMiddleBy;
            if (hasField('jiaoyunLane')) fieldsToUpdate.jiaoyunLane = item.jiaoyunLane;
            if (hasField('jiaoyunLaneBy')) fieldsToUpdate.jiaoyunLaneBy = item.jiaoyunLaneBy;
            if (hasField('huifengLane')) fieldsToUpdate.huifengLane = item.huifengLane;
            if (hasField('huifengLaneBy')) fieldsToUpdate.huifengLaneBy = item.huifengLaneBy;
            if (hasField('deformationValue')) fieldsToUpdate.deformationValue = item.deformationValue;
            if (hasField('deformationValueBy')) fieldsToUpdate.deformationValueBy = item.deformationValueBy;
            if (hasField('deformationNormalMin')) fieldsToUpdate.deformationNormalMin = item.deformationNormalMin;
            if (hasField('deformationNormalMax')) fieldsToUpdate.deformationNormalMax = item.deformationNormalMax;
            if (hasField('pressureCycle')) fieldsToUpdate.pressureCycle = item.pressureCycle;
            if (hasField('pressureCycleBy')) fieldsToUpdate.pressureCycleBy = item.pressureCycleBy;
            if (hasField('daysSincePressure')) fieldsToUpdate.daysSincePressure = item.daysSincePressure;
            if (hasField('hangingRoof')) fieldsToUpdate.hangingRoof = item.hangingRoof;
            if (hasField('hangingRoofBy')) fieldsToUpdate.hangingRoofBy = item.hangingRoofBy;
            if (hasField('surfaceSettlement')) fieldsToUpdate.surfaceSettlement = item.surfaceSettlement;
            if (hasField('surfaceSettlementBy')) fieldsToUpdate.surfaceSettlementBy = item.surfaceSettlementBy;
            if (hasField('conclusion')) fieldsToUpdate.conclusion = item.conclusion;
            if (hasField('conclusionBy')) fieldsToUpdate.conclusionBy = item.conclusionBy;
            if (hasField('remark')) fieldsToUpdate.remark = item.remark;

            const existingCustom = (() => {
                try {
                    const parsed = existing.extraData ? JSON.parse(existing.extraData) : {};
                    return parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? parsed : {};
                } catch (err) {
                    return {};
                }
            })();
            Object.entries(incomingCustomFields).forEach(([key, value]) => {
                existingCustom[key] = value;
            });
            const normalizedCustom = JSON.stringify(existingCustom);
            if ((existing.extraData || '{}') !== normalizedCustom) {
                fieldsToUpdate.extraData = normalizedCustom;
            }
            fieldsToUpdate.status = item.status;
            
            // 检查哪些字段发生了变化
            for (const [field, value] of Object.entries(fieldsToUpdate)) {
                if (existing[field] !== value) {
                    updates.push(`${field} = ?`);
                    params.push(value);
                    // 记录变更日志
                    logOperation(username, 'update', 'daily', existing.id, field, String(existing[field]), String(value));
                }
            }
            
            if (existing.filledBy !== item.filledBy) {
                updates.push('filledBy = ?');
                params.push(item.filledBy);
                logOperation(username, 'update', 'daily', existing.id, 'filledBy', existing.filledBy, item.filledBy);
            }
            
            if (updates.length === 0) {
                return res.json({ success: true, item: attachDailyAliases(existing) });
            }
            
            params.push(existing.id);
            const sql = `UPDATE daily SET ${updates.join(', ')} WHERE id = ?`;
            
            runQuery(sql, params, (success) => {
                if (success) {
                    getSingleQuery('SELECT * FROM daily WHERE id = ?', [existing.id], (updated) => {
                        res.json({ success: true, item: attachDailyAliases(updated) });
                    });
                } else {
                    res.status(500).json({ error: '更新失败' });
                }
            });
        } else {
            // 插入新数据
            const sql = `INSERT INTO daily (
                id, date, workface, suggestedRings, suggestedBy, actualNight, actualNightBy, 
                actualMorning, actualMorningBy, actualMiddle, actualMiddleBy, jiaoyunLane, jiaoyunLaneBy, 
                huifengLane, huifengLaneBy, deformationValue, deformationValueBy, deformationNormalMin, 
                deformationNormalMax, pressureCycle, pressureCycleBy, daysSincePressure, hangingRoof, 
                hangingRoofBy, surfaceSettlement, surfaceSettlementBy, conclusion, conclusionBy, 
                remark, extraData, filledBy, createdAt, status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
            
            const params = [
                item.id, item.date, item.workface, item.suggestedRings, item.suggestedBy, item.actualNight, item.actualNightBy,
                item.actualMorning, item.actualMorningBy, item.actualMiddle, item.actualMiddleBy, item.jiaoyunLane, item.jiaoyunLaneBy,
                item.huifengLane, item.huifengLaneBy, item.deformationValue, item.deformationValueBy, item.deformationNormalMin,
                item.deformationNormalMax, item.pressureCycle, item.pressureCycleBy, item.daysSincePressure, item.hangingRoof,
                item.hangingRoofBy, item.surfaceSettlement, item.surfaceSettlementBy, item.conclusion, item.conclusionBy,
                item.remark, JSON.stringify(incomingCustomFields), item.filledBy, item.createdAt, item.status
            ];
            
            runQuery(sql, params, (success) => {
                if (success) {
                    // 记录插入日志
                    logOperation(username, 'insert', 'daily', item.id, 'all', '', 'New record created');
                    res.json({ success: true, item: attachDailyAliases(item) });
                } else {
                    res.status(500).json({ error: '保存失败' });
                }
            });
        }
    });
});

// 删除每日数据（需要管理员权限）
app.delete('/api/daily/:date', requireAdmin, (req, res) => {
    const workface = req.query.workface;
    const sql = workface ? 'DELETE FROM daily WHERE date = ? AND workface = ?' : 'DELETE FROM daily WHERE date = ?';
    const params = workface ? [req.params.date, workface] : [req.params.date];
    runQuery(sql, params, (success) => {
        if (success) {
            res.json({ success: true });
        } else {
            res.status(500).json({ error: '删除失败' });
        }
    });
});

// 获取操作日志（需要管理员权限）
app.get('/api/logs', (req, res) => {
    const { username, role } = req.query;
    
    // 检查是否为管理员
    if (role !== 'admin') {
        return res.status(403).json({ error: '权限不足' });
    }
    
    getQuery('SELECT * FROM logs ORDER BY timestamp DESC', [], (rows) => {
        res.json(rows);
    });
});

// 获取统计数据
app.get('/api/daily/stats', (req, res) => {
    let sql = 'SELECT * FROM daily';
    let params = [];
    
    // 根据工作面过滤
    const workface = req.query.workface;
    if (workface) {
        sql += ' WHERE workface = ?';
        params.push(workface);
    }
    
    getQuery(sql, params, (data) => {
        data = data.map(attachDailyAliases);
        const now = new Date();
        const thisMonth = data.filter(d => {
            const dDate = new Date(d.date);
            return dDate.getFullYear() === now.getFullYear() && dDate.getMonth() === now.getMonth();
        });
        
        const pressureItems = data.filter(d => d.pressureCycle === '是').sort((a, b) => new Date(b.date) - new Date(a.date));
        let avgCycle = 0;
        if (pressureItems.length >= 2) {
            let totalDays = 0;
            for (let i = 1; i < pressureItems.length; i++) {
                const diff = new Date(pressureItems[i-1].date) - new Date(pressureItems[i].date);
                totalDays += diff / (1000 * 60 * 60 * 24);
            }
            avgCycle = (totalDays / (pressureItems.length - 1)).toFixed(1);
        }
        
        const stats = {
            totalDays: data.length,
            thisMonth: thisMonth.length,
            totalRings: data.reduce((sum, d) => sum + (d.actualNight || 0) + (d.actualMorning || 0) + (d.actualMiddle || 0), 0),
            thisMonthRings: thisMonth.reduce((sum, d) => sum + (d.actualNight || 0) + (d.actualMorning || 0) + (d.actualMiddle || 0), 0),
            pressureCount: pressureItems.length,
            avgPressureCycle: avgCycle || '暂无数据'
        };
        
        res.json(stats);
    });
});

app.get('/api/records', requireAdmin, (req, res) => {
    getQuery('SELECT * FROM daily ORDER BY date DESC, createdAt DESC', [], (rows) => {
        const records = rows.map(row => ({
            id: row.id,
            date: row.date,
            workface: row.workface,
            username: row.filledBy || '-',
            shift: '-',
            data: attachDailyAliases(row)
        }));
        res.json(records);
    });
});

app.delete('/api/records/:id', requireAdmin, (req, res) => {
    runQuery('DELETE FROM daily WHERE id = ?', [req.params.id], (success) => {
        if (success) {
            res.json({ success: true });
        } else {
            res.status(500).json({ error: '删除失败' });
        }
    });
});

// ===== 用户专属数据 API =====
app.get('/api/daily/user/:username', (req, res) => {
    const { username } = req.params;
    
    // 获取用户信息
    getSingleQuery('SELECT * FROM users WHERE username = ?', [username], (user) => {
        if (!user) {
            return res.status(404).json({ error: '用户不存在' });
        }
        
        const today = new Date().toISOString().split('T')[0];
        const yesterday = new Date();
        yesterday.setDate(yesterday.getDate() - 1);
        const yesterdayStr = yesterday.toISOString().split('T')[0];
        
        // 返回用户可以填写的工作面的最新数据
        const userWorkfaces = user.workface ? user.workface.split(',') : [];
        const result = {};
        
        // 递归获取每个工作面的数据
        let count = 0;
        userWorkfaces.forEach(wf => {
            getSingleQuery('SELECT * FROM daily WHERE date = ? AND workface = ?', [today, wf], (todayData) => {
                if (todayData) {
                    result[wf] = todayData;
                } else {
                    getSingleQuery('SELECT * FROM daily WHERE date = ? AND workface = ?', [yesterdayStr, wf], (yesterdayData) => {
                        result[wf] = yesterdayData || null;
                        count++;
                        if (count === userWorkfaces.length) {
                            res.json({
                                user: { id: user.id, username: user.username, role: user.role, workface: user.workface, name: user.name },
                                data: result
                            });
                        }
                    });
                }
            });
        });
        
        if (userWorkfaces.length === 0) {
            res.json({
                user: { id: user.id, username: user.username, role: user.role, workface: user.workface, name: user.name },
                data: result
            });
        }
    });
});

initDatabase()
    .then(() => {
        app.listen(PORT, '0.0.0.0', () => {
            console.log(`综合风险研判系统运行在: http://localhost:${PORT}`);
        });
    })
    .catch((err) => {
        console.error('Failed to initialize MySQL database:', err.message);
        process.exit(1);
    });
