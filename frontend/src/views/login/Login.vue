<template>
  <div class="login-container">
    <!-- 背景网格 -->
    <div class="grid-background"></div>
    
    <!-- 科技感线条 -->
    <div class="tech-lines">
      <div class="line line-1"></div>
      <div class="line line-2"></div>
      <div class="line line-3"></div>
      <div class="line line-4"></div>
    </div>
    
    <!-- 霓虹光效 -->
    <div class="neon-glow"></div>
    
    <div class="login-card">
      <div class="login-header">
        <div class="logo">
          <div class="logo-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="#00ffea" stroke-width="2" stroke-linejoin="round"/>
              <path d="M12 8V16" stroke="#00ffea" stroke-width="2" stroke-linecap="round"/>
              <path d="M8 12H16" stroke="#00ffea" stroke-width="2" stroke-linecap="round"/>
              <path d="M12 2V22" stroke="#00ffea" stroke-width="1" stroke-dasharray="2 4" opacity="0.5"/>
              <path d="M2 12H22" stroke="#00ffea" stroke-width="1" stroke-dasharray="2 4" opacity="0.5"/>
            </svg>
          </div>
          <h1>LOWCODE<span class="highlight">PRO</span></h1>
          <p class="subtitle">企业级低代码开发平台</p>
        </div>
      </div>
      
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <div class="input-wrapper">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M17 21V19C17 17.9391 16.5786 16.9217 15.8284 16.1716C15.0783 15.4214 14.0609 15 13 15H5C3.93913 15 2.92172 15.4214 2.17157 16.1716C1.42143 16.9217 1 17.9391 1 19V21" stroke="#00ffea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 11C11.2091 11 13 9.20914 13 7C13 4.79086 11.2091 3 9 3C6.79086 3 5 4.79086 5 7C5 9.20914 6.79086 11 9 11Z" stroke="#00ffea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </span>
            <input 
              type="text" 
              v-model="form.tenantCode" 
              placeholder="租户编码" 
              class="form-input"
            />
          </div>
        </div>
        
        <div class="form-group">
          <div class="input-wrapper">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M16 7C16 9.20914 14.2091 11 12 11C9.79086 11 8 9.20914 8 7C8 4.79086 9.79086 3 12 3C14.2091 3 16 4.79086 16 7Z" stroke="#00ffea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M16 21V16C16 14.8954 15.1046 14 14 14H10C8.89543 14 8 14.8954 8 16V21" stroke="#00ffea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </span>
            <input 
              type="text" 
              v-model="form.username" 
              placeholder="账号" 
              class="form-input"
            />
          </div>
        </div>
        
        <div class="form-group">
          <div class="input-wrapper">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 15V17M12 7V9M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="#00ffea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </span>
            <input 
              type="password" 
              v-model="form.password" 
              placeholder="密码" 
              class="form-input"
            />
          </div>
        </div>
        
        <div class="form-actions">
          <button 
            type="submit" 
            :disabled="loading" 
            class="login-button"
          >
            <span v-if="loading" class="loading-spinner"></span>
            <span v-else>
              <span class="button-text">登录</span>
              <span class="button-arrow">→</span>
            </span>
          </button>
        </div>
        
        <div v-if="errorMsg" class="error-message">
          <div class="error-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 8V12M12 16H12.01M22 12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2C17.5228 2 22 6.47715 22 12Z" stroke="#ff4757" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <span>{{ errorMsg }}</span>
        </div>
        
        <div class="form-footer">
          <div class="tech-info">
            <span class="version">v1.0.0</span>
            <span class="powered-by">Powered by LowCode Pro</span>
          </div>
          <div class="copyright">
            © 2026 LowCode Pro | 企业级应用解决方案
          </div>
        </div>
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
/* 科技感深色主题 */
.login-container {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: #0a0a0f;
  overflow: hidden;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* 网格背景 */
.grid-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: 
    linear-gradient(rgba(0, 255, 234, 0.1) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 255, 234, 0.1) 1px, transparent 1px);
  background-size: 50px 50px;
  z-index: 1;
  animation: gridMove 20s linear infinite;
}

@keyframes gridMove {
  0% {
    transform: translate(0, 0);
  }
  100% {
    transform: translate(50px, 50px);
  }
}

/* 科技线条 */
.tech-lines {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 2;
}

.line {
  position: absolute;
  background: linear-gradient(90deg, transparent, rgba(0, 255, 234, 0.3), transparent);
  height: 1px;
  animation: lineMove 8s ease-in-out infinite;
}

.line-1 {
  top: 20%;
  left: -100%;
  width: 200%;
  animation-delay: 0s;
}

.line-2 {
  top: 40%;
  left: 100%;
  width: 200%;
  animation-delay: 2s;
  animation-direction: reverse;
}

.line-3 {
  top: 60%;
  left: -100%;
  width: 200%;
  animation-delay: 4s;
}

.line-4 {
  top: 80%;
  left: 100%;
  width: 200%;
  animation-delay: 6s;
  animation-direction: reverse;
}

@keyframes lineMove {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(100%);
  }
}

/* 霓虹光效 */
.neon-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(0, 255, 234, 0.1) 0%, transparent 70%);
  border-radius: 50%;
  z-index: 1;
  animation: glowPulse 4s ease-in-out infinite;
}

@keyframes glowPulse {
  0%, 100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.1);
    opacity: 0.8;
  }
}

/* 登录卡片 */
.login-card {
  position: relative;
  z-index: 3;
  width: 400px;
  background: rgba(10, 10, 15, 0.8);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(0, 255, 234, 0.2);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 
    0 0 30px rgba(0, 255, 234, 0.1),
    inset 0 0 30px rgba(0, 255, 234, 0.05);
  transition: all 0.3s ease;
  overflow: hidden;
}

.login-card::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg, transparent, rgba(0, 255, 234, 0.1), transparent);
  transform: rotate(45deg);
  animation: shine 6s linear infinite;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.login-card:hover::before {
  opacity: 1;
}

@keyframes shine {
  0% {
    transform: translateX(-100%) rotate(45deg);
  }
  100% {
    transform: translateX(100%) rotate(45deg);
  }
}

.login-card:hover {
  box-shadow: 
    0 0 40px rgba(0, 255, 234, 0.2),
    inset 0 0 40px rgba(0, 255, 234, 0.1);
  transform: translateY(-5px);
}

/* 登录头部 */
.login-header {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
  z-index: 4;
}

.logo {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}

.logo-icon {
  width: 80px;
  height: 80px;
  background: rgba(0, 255, 234, 0.1);
  border: 1px solid rgba(0, 255, 234, 0.3);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: logoPulse 2s ease-in-out infinite;
  position: relative;
  overflow: hidden;
}

.logo-icon::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(0, 255, 234, 0.2), transparent);
  animation: logoShine 3s ease-in-out infinite;
}

@keyframes logoPulse {
  0%, 100% {
    box-shadow: 0 0 20px rgba(0, 255, 234, 0.3);
  }
  50% {
    box-shadow: 0 0 30px rgba(0, 255, 234, 0.5);
  }
}

@keyframes logoShine {
  0% {
    left: -100%;
  }
  100% {
    left: 100%;
  }
}

.logo-icon svg {
  width: 40px;
  height: 40px;
  z-index: 1;
}

h1 {
  font-size: 32px;
  font-weight: 700;
  color: #ffffff;
  margin: 0;
  text-shadow: 0 0 10px rgba(0, 255, 234, 0.5);
  letter-spacing: 2px;
}

.highlight {
  color: #00ffea;
  position: relative;
}

.highlight::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, #00ffea, transparent);
  animation: underlineMove 2s ease-in-out infinite;
}

@keyframes underlineMove {
  0%, 100% {
    width: 0;
    left: 0;
  }
  50% {
    width: 100%;
    left: 0;
  }
}

.subtitle {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0;
  letter-spacing: 1px;
}

/* 登录表单 */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
  position: relative;
  z-index: 4;
}

.form-group {
  position: relative;
}

.input-wrapper {
  position: relative;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(0, 255, 234, 0.3);
  border-radius: 12px;
  transition: all 0.3s ease;
  overflow: hidden;
}

.input-wrapper:focus-within {
  border-color: #00ffea;
  box-shadow: 0 0 15px rgba(0, 255, 234, 0.3);
  background: rgba(255, 255, 255, 0.08);
}

.input-icon {
  position: absolute;
  left: 20px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 1;
  transition: all 0.3s ease;
}

.input-wrapper:focus-within .input-icon {
  color: #00ffea;
  filter: drop-shadow(0 0 5px #00ffea);
}

.input-icon svg {
  width: 18px;
  height: 18px;
}

.form-input {
  width: 100%;
  padding: 16px 20px 16px 56px;
  border: none;
  background: transparent;
  font-size: 14px;
  color: #ffffff;
  outline: none;
  transition: all 0.3s ease;
}

.form-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.form-input:focus {
  color: #00ffea;
}

/* 登录按钮 */
.form-actions {
  margin-top: 8px;
}

.login-button {
  width: 100%;
  padding: 16px;
  background: linear-gradient(135deg, rgba(0, 255, 234, 0.2), rgba(0, 255, 234, 0.1));
  color: #00ffea;
  border: 1px solid rgba(0, 255, 234, 0.5);
  border-radius: 12px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  position: relative;
  overflow: hidden;
}

.login-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(0, 255, 234, 0.2), transparent);
  transition: left 0.5s ease;
}

.login-button:hover::before {
  left: 100%;
}

.login-button:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(0, 255, 234, 0.3), rgba(0, 255, 234, 0.2));
  box-shadow: 0 0 20px rgba(0, 255, 234, 0.4);
  transform: translateY(-3px);
}

.login-button:disabled {
  background: rgba(0, 255, 234, 0.1);
  border-color: rgba(0, 255, 234, 0.2);
  color: rgba(0, 255, 234, 0.5);
  cursor: not-allowed;
}

.button-text {
  position: relative;
  z-index: 1;
}

.button-arrow {
  position: relative;
  z-index: 1;
  transition: transform 0.3s ease;
}

.login-button:hover .button-arrow {
  transform: translateX(5px);
}

/* 加载动画 */
.loading-spinner {
  width: 20px;
  height: 20px;
  border: 2px solid rgba(0, 255, 234, 0.3);
  border-top: 2px solid #00ffea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  position: relative;
  z-index: 1;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 错误信息 */
.error-message {
  background: rgba(255, 71, 87, 0.1);
  color: #ff4757;
  padding: 16px;
  border-radius: 8px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  border-left: 4px solid #ff4757;
  animation: errorSlideIn 0.3s ease;
  position: relative;
  z-index: 4;
}

@keyframes errorSlideIn {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.error-icon svg {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

/* 页脚 */
.form-footer {
  margin-top: 32px;
  position: relative;
  z-index: 4;
}

.tech-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.4);
}

.version {
  background: rgba(0, 255, 234, 0.1);
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid rgba(0, 255, 234, 0.2);
}

.copyright {
  text-align: center;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.3);
  letter-spacing: 0.5px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-card {
    width: 90%;
    max-width: 400px;
    padding: 32px 24px;
  }
  
  h1 {
    font-size: 28px;
  }
  
  .logo-icon {
    width: 64px;
    height: 64px;
  }
  
  .logo-icon svg {
    width: 32px;
    height: 32px;
  }
}

@media (max-width: 480px) {
  .login-card {
    width: 95%;
    padding: 24px 20px;
  }
  
  h1 {
    font-size: 24px;
  }
  
  .grid-background {
    background-size: 30px 30px;
  }
  
  .neon-glow {
    width: 400px;
    height: 400px;
  }
}
</style>
