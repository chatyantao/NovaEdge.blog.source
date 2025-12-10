<!-- 这是未解锁时看到的区域（全站通用） -->
<div class="vip-paywall" id="novaedge-vip-paywall">
  <p><strong>🔒 会员专享内容</strong></p>
  <p>以下内容仅对 <strong>NovaEdge 会员</strong> 开放。</p>
  <ol>
    <li>前往 <a href="https://afdian.net/a/你的主页ID" target="_blank">爱发电 · NovaEdge 会员</a> ，用微信 / 支付宝支持即可成为会员。</li>
    <li>你会在爱发电收到一条带有 <strong>解锁密码</strong> 的私信 / 回报。</li>
    <li>在下方输入密码，全站会员内容将一次性解锁。</li>
  </ol>
  <input type="password" id="novaedge-vip-password" placeholder="输入会员解锁密码">
  <button type="button" onclick="window.novaedgeUnlockVip()">解锁全站内容</button>
</div>

<!-- 这是会员专享的真实内容（只要解锁一次，全站都会显示） -->
<div class="vip-only" style="display:none; margin-top: 1rem;">
  <h2>（会员专享）NovaEdge 深度实战内容</h2>
  <p>👉 在这里写你的“会员可见内容”，比如完整 JSON 模板、独家提示词库、内部工作流、项目文件下载链接等等。</p>
</div>

<script>
  (function () {
    // 你给会员的全站解锁密码
    var REAL_VIP_PASSWORD = 'NovaEdgeVIP2025';  // ← 这里改成你自己的密码

    function setVipFlag() {
      localStorage.setItem('novaedge_vip', 'yes');
    }
    
    function isVip() {
      return localStorage.getItem('novaedge_vip') === 'yes';
    }
    
    function showVipContent() {
      // 显示所有 vip-only 区块，隐藏所有 vip-paywall 区块
      var vipBlocks = document.querySelectorAll('.vip-only');
      var paywalls  = document.querySelectorAll('.vip-paywall');
      vipBlocks.forEach(function (el) { el.style.display = 'block'; });
      paywalls.forEach(function (el) { el.style.display = 'none'; });
    }
    
    function unlockVip() {
      var input = document.getElementById('novaedge-vip-password');
      if (!input) {
        alert('页面上没有找到密码输入框。');
        return;
      }
      var value = input.value.trim();
      if (value === REAL_VIP_PASSWORD) {
        setVipFlag();
        showVipContent();
        alert('解锁成功，你现在可以查看站内所有会员内容。');
      } else {
        alert('密码不正确，请确认你在爱发电收到的解锁密码。');
      }
    }
    
    // 暴露到全局，给按钮 onclick 用
    window.novaedgeUnlockVip = unlockVip;
    
    // 页面加载时，如果已经是 VIP，自动展示所有会员内容
    window.addEventListener('load', function () {
      if (isVip()) {
        showVipContent();
      }
    });
  })();
</script>