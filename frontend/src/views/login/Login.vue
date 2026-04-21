<template>
  <div class="login-container">
    <div class="login-card">
      <h2>低代码平台登录</h2>
      <form @submit.prevent="handleLogin">
        <div class="form-item">
          <label>租户</label>
          <input type="text" v-model="form.tenantCode" placeholder="请输入租户编码" />
        </div>
        <div class="form-item">
          <label>账号</label>
          <input type="text" v-model="form.username" placeholder="请输入账号" />
        </div>
        <div class="form-item">
          <label>密码</label>
          <input type="password" v-model="form.password" placeholder="请输入密码" />
        </div>
        <button type="submit" :disabled="loading">登录</button>
        <div v-if="errorMsg" class="error">{{ errorMsg }}</div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const errorMsg = ref('')

const form = ref({
  tenantCode: 'default',
  username: 'admin',
  password: 'admin123'
})

const handleLogin = async () => {
  loading.value = true
  errorMsg.value = ''
  
  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form.value)
    })
    
    const data = await response.json()
    
    if (data.success) {
      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(data.user))
      router.push('/')
    } else {
      errorMsg.value = data.message
    }
  } catch (err) {
    errorMsg.value = '网络错误，请确保后端已启动'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: #f0f2f5;
}
.login-card {
  width: 400px;
  padding: 30px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.1);
}
h2 {
  text-align: center;
  margin-bottom: 30px;
}
.form-item {
  margin-bottom: 20px;
}
label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}
input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}
button {
  width: 100%;
  padding: 10px;
  background: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}
button:disabled {
  background: #a0cfff;
}
.error {
  margin-top: 10px;
  color: red;
  text-align: center;
}
</style>
