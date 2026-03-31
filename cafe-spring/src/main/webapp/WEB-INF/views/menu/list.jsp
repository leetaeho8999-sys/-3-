<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="메뉴 — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <section class="menu-section">
    <div class="container">
      <div class="section-header">
        <h2>메뉴</h2>
        <p>정성스럽게 준비한 다양한 커피 메뉴를 만나보세요</p>
      </div>
      <div class="menu-cat-tabs">
        <a href="?category=전체"     class="cat-tab ${category=='전체'?'active':''}">전체</a>
        <a href="?category=espresso" class="cat-tab ${category=='espresso'?'active':''}">에스프레소</a>
        <a href="?category=latte"    class="cat-tab ${category=='latte'?'active':''}">라떼</a>
        <a href="?category=special"  class="cat-tab ${category=='special'?'active':''}">스페셜</a>
      </div>
      <div class="menu-grid">
        <c:forEach var="m" items="${menuList}">
          <a href="${pageContext.request.contextPath}/menu/detail?m_idx=${m.m_idx}" class="menu-card">
            <div class="menu-img"><img src="${m.imageUrl}" alt="${m.name}"></div>
            <div class="menu-body">
              <div class="menu-title-row"><h4>${m.name}</h4><span class="menu-price">${m.price}원</span></div>
              <p>${m.description}</p>
            </div>
          </a>
        </c:forEach>
        <c:if test="${empty menuList}"><p class="text-muted text-center" style="padding:3rem">준비 중입니다.</p></c:if>
      </div>
    </div>
  </section>
</main>
<%@ include file="../common/footer.jsp" %>
