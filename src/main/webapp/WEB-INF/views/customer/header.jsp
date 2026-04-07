<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BREW CRM</title>
  
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div id="video-bg">
  <video autoplay muted loop playsinline id="bg-video">
    <source src="https://videos.pexels.com/video-files/3737294/3737294-hd_1920_1080_25fps.mp4" type="video/mp4">
  </video>
  <div id="video-overlay"></div>
</div>

<div id="app">
  <aside id="sidebar">
    <div id="sidebar-logo">
      <span class="logo-icon">☕</span>
      <div>
        <div class="logo-title">BREW</div>
        <div class="logo-sub">Customer CRM</div>
      </div>
    </div>
    <nav id="sidebar-nav">
      <a href="${pageContext.request.contextPath}/customer/dashboard"
         class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
        <span class="nav-icon">▪</span> 대시보드
      </a>
      <a href="${pageContext.request.contextPath}/customer/register"
         class="nav-item ${activeMenu == 'register' ? 'active' : ''}">
        <span class="nav-icon">+</span> 고객 등록
      </a>
      <a href="${pageContext.request.contextPath}/customer/list"
         class="nav-item ${activeMenu == 'list' ? 'active' : ''}">
        <span class="nav-icon">≡</span> 고객 목록
      </a>
      <a href="${pageContext.request.contextPath}/customer/stats"
         class="nav-item ${activeMenu == 'stats' ? 'active' : ''}">
        <span class="nav-icon">◎</span> 통계
      </a>
      <a href="${pageContext.request.contextPath}/customer/marketing"
         class="nav-item ${activeMenu == 'marketing' ? 'active' : ''}">
        <span class="nav-icon">◈</span> 마케팅
      </a>
      <a href="${pageContext.request.contextPath}/customer/admin"
         class="nav-item ${activeMenu == 'admin' ? 'active' : ''}">
        <span class="nav-icon">⚙</span> 시스템 관리
      </a>
      <!-- 회원 마이페이지 링크 -->
      <a href="${pageContext.request.contextPath}/member/mypage"
         class="nav-item" style="margin-top:12px;border-top:1px solid var(--border);padding-top:16px">
        <span class="nav-icon">◉</span> 마이페이지
      </a>
      <a href="${pageContext.request.contextPath}/member/logout"
         class="nav-item">
        <span class="nav-icon">→</span> 로그아웃
      </a>
    </nav>
    <div id="sidebar-footer">
      <div class="sidebar-date" id="sidebar-date"></div>
    </div>
  </aside>

  <div id="main-wrap">
    <header id="topbar">
      <div id="topbar-title">${pageTitle}</div>
      <form action="${pageContext.request.contextPath}/customer/list" method="get" id="topbar-search">
        <input type="text" name="keyword" value="${keyword}" placeholder="이름 또는 연락처 검색...">
        <button type="submit">검색</button>
        <a href="${pageContext.request.contextPath}/customer/list" class="btn-reset">전체</a>
      </form>
    </header>
    <main id="content">
