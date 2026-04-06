<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="${menu.name} — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <div class="container" style="padding-top:3rem;max-width:700px">
    <a href="${pageContext.request.contextPath}/menu/list" class="btn-ghost" style="margin-bottom:1.5rem;display:inline-flex">← 메뉴 목록</a>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:2rem;align-items:start">
      <img src="${menu.imageUrl}" alt="${menu.name}" style="width:100%;border-radius:.625rem;aspect-ratio:1/1;object-fit:cover">
      <div>
        <h1 style="font-family:'Noto Serif KR',serif;font-size:2rem;font-weight:400;margin-bottom:.5rem">${menu.name}</h1>
        <p style="font-size:1.3rem;color:#c8832a;font-weight:500;margin-bottom:1rem">${menu.price}원</p>
        <p style="color:#717182;margin-bottom:1.5rem">${menu.description}</p>
        <div style="background:#f8f8f9;border-radius:.625rem;padding:1rem;margin-bottom:1.5rem">
          <p style="font-size:.875rem;font-weight:500;margin-bottom:.25rem">원산지</p>
          <p style="font-size:.875rem;color:#717182">${menu.origin}</p>
        </div>
        <div style="background:#f8f8f9;border-radius:.625rem;padding:1rem">
          <p style="font-size:.875rem;font-weight:500;margin-bottom:.5rem">스토리</p>
          <p style="font-size:.875rem;color:#717182;line-height:1.8;white-space:pre-line">${menu.story}</p>
        </div>
      </div>
    </div>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
