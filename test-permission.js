const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));

// 测试更新用户权限
async function testUpdateUser() {
  try {
    const response = await fetch('http://localhost:5002/api/users/4cd65bfc-f580-4f67-a01c-599463839aff', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        role: 'user',
        fields: ['actualNight', 'actualMorning', 'actualMiddle']
      })
    });
    
    const data = await response.json();
    console.log('Response:', data);
    
    // 检查用户权限
    const userResponse = await fetch('http://localhost:5002/api/users');
    const users = await userResponse.json();
    const user = users.find(u => u.username === '111111');
    console.log('User:', user);
  } catch (error) {
    console.error('Error:', error);
  }
}

testUpdateUser();
