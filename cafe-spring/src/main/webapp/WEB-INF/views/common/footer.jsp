<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<footer class="site-footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <h3>로운</h3>
        <p>한 잔의 커피에 담긴<br>진심과 정성</p>
      </div>
      <div class="footer-links">
        <h4>링크</h4>
        <ul>
          <li><a href="${pageContext.request.contextPath}/about">소개</a></li>
          <li><a href="${pageContext.request.contextPath}/menu/list">메뉴</a></li>
          <li><a href="${pageContext.request.contextPath}/chat">AI 상담</a></li>
          <li><a href="${pageContext.request.contextPath}/contact">문의</a></li>
          <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
        </ul>
      </div>
      <div class="footer-social">
        <h4>소셜 미디어</h4>
        <div class="social-icons">
          <button class="social-btn">📷</button>
          <button class="social-btn">📘</button>
          <button class="social-btn">▶</button>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p>&copy; 2026 로운. All rights reserved.</p>
      <p>사업자등록번호: 123-45-67890 | 대표: 홍길동</p>
      <div class="footer-legal">
        <a href="${pageContext.request.contextPath}/privacy-policy">개인정보 처리방침</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/terms-of-service">이용약관</a>
      </div>
    </div>
  </div>
</footer>
<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
</body>
</html>
