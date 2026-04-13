<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty pageTitle ? pageTitle : '로운'}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@300;400;500&family=Noto+Sans+KR:wght@300;400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<header class="site-header" id="site-header">
  <div class="header-inner">
    <a href="${pageContext.request.contextPath}/" class="header-logo">로운</a>
    <nav class="header-nav">
      <a href="${pageContext.request.contextPath}/" class="nav-link">홈</a>
      <a href="${pageContext.request.contextPath}/about" class="nav-link">소개</a>
      <div class="nav-dropdown">
        <button class="nav-link nav-dropdown-btn" onclick="toggleDropdown()">메뉴 <span class="chevron" id="chevron">▾</span></button>
        <div class="dropdown-menu" id="dropdown-menu">
          <a href="${pageContext.request.contextPath}/menu/list" class="dropdown-item">커피 메뉴</a>
          <a href="${pageContext.request.contextPath}/membership/list" class="dropdown-item">멤버십</a>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/board/list" class="nav-link">게시판</a>
      <a href="${pageContext.request.contextPath}/chat" class="nav-link">AI 상담</a>
      <a href="${pageContext.request.contextPath}/contact" class="nav-link">문의</a>
      <a href="${pageContext.request.contextPath}/faq" class="nav-link">FAQ</a>
      <div class="nav-auth">
        <c:choose>
          <c:when test="${not empty sessionScope.m_id}">
            <div class="nav-dropdown">
              <button class="user-btn" onclick="toggleUserDropdown()">👤 ${sessionScope.m_name} ▾</button>
              <div class="user-dropdown" id="user-dropdown">
                <a href="${pageContext.request.contextPath}/member/logout" class="dropdown-item">로그아웃</a>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/member/login" class="nav-link">로그인</a>
            <a href="${pageContext.request.contextPath}/member/register" class="btn-register">회원가입</a>
          </c:otherwise>
        </c:choose>
      </div>
    </nav>
    <button class="mobile-menu-btn" onclick="toggleMobileMenu()"><span id="hamburger-icon">☰</span></button>
  </div>
  <div class="mobile-nav" id="mobile-nav">
    <a href="${pageContext.request.contextPath}/" class="mobile-nav-link">홈</a>
    <a href="${pageContext.request.contextPath}/about" class="mobile-nav-link">소개</a>
    <a href="${pageContext.request.contextPath}/menu/list" class="mobile-nav-link">커피 메뉴</a>
    <a href="${pageContext.request.contextPath}/board/list" class="mobile-nav-link">게시판</a>
    <a href="${pageContext.request.contextPath}/chat" class="mobile-nav-link">AI 상담</a>
    <a href="${pageContext.request.contextPath}/contact" class="mobile-nav-link">문의</a>
    <a href="${pageContext.request.contextPath}/faq" class="mobile-nav-link">FAQ</a>
    <div class="mobile-nav-divider"></div>
    <c:choose>
      <c:when test="${not empty sessionScope.m_id}">
        <a href="${pageContext.request.contextPath}/member/logout" class="mobile-nav-link">로그아웃</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/member/login" class="mobile-nav-link">로그인</a>
        <a href="${pageContext.request.contextPath}/member/register" class="mobile-nav-link" style="color:#e8a84c">회원가입</a>
      </c:otherwise>
    </c:choose>
  </div>
</header>
