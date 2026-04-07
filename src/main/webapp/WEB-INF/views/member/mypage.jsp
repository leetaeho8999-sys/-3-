<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>BREW CRM — 마이페이지</title>
  
  
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
  <!-- 사이드바 -->
  <aside id="sidebar">
    <div id="sidebar-logo">
      <span class="logo-icon">☕</span>
      <div>
        <div class="logo-title">BREW</div>
        <div class="logo-sub">My Page</div>
      </div>
    </div>
    <nav id="sidebar-nav">
      <a href="${pageContext.request.contextPath}/member/mypage" class="nav-item active">
        <span class="nav-icon">◎</span> 내 정보
      </a>
      <%-- STAFF / MANAGER / ADMIN 은 CRM 대시보드로 이동 가능 --%>
      <c:if test="${sessionScope.loginMember.role != 'MEMBER' and not empty sessionScope.loginMember.role}">
        <a href="${pageContext.request.contextPath}/customer/dashboard"
           class="nav-item" style="margin-top:12px;border-top:1px solid rgba(255,255,255,.12);padding-top:16px">
          <span class="nav-icon">◀</span> CRM 대시보드
        </a>
      </c:if>
      <a href="${pageContext.request.contextPath}/member/logout" class="nav-item">
        <span class="nav-icon">→</span> 로그아웃
      </a>
    </nav>
    <div id="sidebar-footer">
      <div class="sidebar-date" id="sidebar-date"></div>
    </div>
  </aside>

  <div id="main-wrap">
    <header id="topbar">
      <div id="topbar-title">마이페이지</div>
      <div style="display:flex;align-items:center;gap:12px">
        <span style="color:var(--white-dim);font-size:13px">${myInfo.name}님</span>
        <c:if test="${sessionScope.loginMember.role != 'MEMBER' and not empty sessionScope.loginMember.role}">
          <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn-reset"
             style="background:rgba(100,180,255,.18)">◀ CRM</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/member/logout" class="btn-reset">로그아웃</a>
      </div>
    </header>

    <main id="content">

      <c:if test="${param.updated == 'true'}">
        <div class="alert-success-banner">✓ 정보가 업데이트되었습니다.</div>
      </c:if>

      <!-- ══════════════════════════════════════════
           등급 카드 (마이페이지 핵심)
           ════════════════════════════════════════ -->
      <div class="grade-hero-card glass-card">
        <div class="grade-hero-inner">

          <!-- 등급 아이콘 + 이름 -->
          <div class="grade-hero-badge">
            <c:choose>
              <c:when test="${myInfo.grade == 'VIP'}">
                <div class="grade-crown">👑</div>
                <div class="grade-big-badge grade-VIP">VIP</div>
              </c:when>
              <c:when test="${myInfo.grade == '골드'}">
                <div class="grade-crown">⭐</div>
                <div class="grade-big-badge grade-골드">골드</div>
              </c:when>
              <c:when test="${myInfo.grade == '실버'}">
                <div class="grade-crown">🥈</div>
                <div class="grade-big-badge grade-실버">실버</div>
              </c:when>
              <c:otherwise>
                <div class="grade-crown">☕</div>
                <div class="grade-big-badge grade-일반">일반</div>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- 이름 + 방문 횟수 -->
          <div class="grade-hero-info">
            <div class="grade-member-name">${myInfo.name} 님</div>
            <div class="grade-visit-count">총 방문 횟수: <strong>${myInfo.visitCount}회</strong></div>

            <!-- 다음 등급 진행 바 -->
            <c:choose>
              <c:when test="${myInfo.grade == 'VIP'}">
                <div class="grade-progress-label">최상위 등급 달성! 🎉</div>
                <div class="grade-progress-bar"><div class="grade-progress-fill" style="width:100%;background:linear-gradient(90deg,#b464dc,#cc88ff)"></div></div>
              </c:when>
              <c:when test="${myInfo.grade == '골드'}">
                <div class="grade-progress-label">VIP까지 이번 달 <strong>${30 - myInfo.monthlyVisit}회</strong> 남음</div>
                <div class="grade-progress-bar">
                  <div class="grade-progress-fill grade-fill-gold" style="width:${((myInfo.monthlyVisit - 15) * 100) / 15}%"></div>
                </div>
                <div class="grade-progress-range"><span>골드 15회</span><span>VIP 30회</span></div>
              </c:when>
              <c:when test="${myInfo.grade == '실버'}">
                <div class="grade-progress-label">골드까지 이번 달 <strong>${15 - myInfo.monthlyVisit}회</strong> 남음</div>
                <div class="grade-progress-bar">
                  <div class="grade-progress-fill grade-fill-silver" style="width:${((myInfo.monthlyVisit - 5) * 100) / 10}%"></div>
                </div>
                <div class="grade-progress-range"><span>실버 5회</span><span>골드 15회</span></div>
              </c:when>
              <c:otherwise>
                <div class="grade-progress-label">실버까지 이번 달 <strong>${5 - myInfo.monthlyVisit}회</strong> 남음</div>
                <div class="grade-progress-bar">
                  <div class="grade-progress-fill grade-fill-normal" style="width:${(myInfo.monthlyVisit * 100) / 5}%"></div>
                </div>
                <div class="grade-progress-range"><span>일반 0회</span><span>실버 5회</span></div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- 등급별 혜택 -->
        <div class="grade-benefits">
          <div class="grade-benefit-title">현재 등급 혜택</div>
          <div class="grade-benefit-list">
            <c:choose>
              <c:when test="${myInfo.grade == 'VIP'}">
                <div class="grade-benefit-item">👑 전 메뉴 20% 상시 할인</div>
                <div class="grade-benefit-item">☕ 매달 무료 음료 2잔 제공</div>
                <div class="grade-benefit-item">🎂 생일 케이크 무료 제공</div>
                <div class="grade-benefit-item">🔔 신메뉴 출시 전 사전 알림</div>
              </c:when>
              <c:when test="${myInfo.grade == '골드'}">
                <div class="grade-benefit-item">⭐ 전 메뉴 15% 상시 할인</div>
                <div class="grade-benefit-item">☕ 매달 무료 음료 1잔 제공</div>
                <div class="grade-benefit-item">🎁 포인트 2배 적립</div>
              </c:when>
              <c:when test="${myInfo.grade == '실버'}">
                <div class="grade-benefit-item">🥈 전 메뉴 10% 할인</div>
                <div class="grade-benefit-item">🎁 포인트 1.5배 적립</div>
              </c:when>
              <c:otherwise>
                <div class="grade-benefit-item">☕ 기본 포인트 적립</div>
                <div class="grade-benefit-item">📍 방문할수록 등급 상승!</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 등급 안내 -->
      <div class="grade-steps glass-card">
        <div class="card-header"><h3>등급 안내</h3></div>
        <div class="grade-step-grid">
          <div class="grade-step ${myInfo.grade == '일반' ? 'grade-step-active' : ''}">
            <span class="grade-badge grade-일반">일반</span>
            <div class="grade-step-desc">0 ~ 4회</div>
          </div>
          <div class="grade-step-arrow">→</div>
          <div class="grade-step ${myInfo.grade == '실버' ? 'grade-step-active' : ''}">
            <span class="grade-badge grade-실버">실버</span>
            <div class="grade-step-desc">5 ~ 14회</div>
          </div>
          <div class="grade-step-arrow">→</div>
          <div class="grade-step ${myInfo.grade == '골드' ? 'grade-step-active' : ''}">
            <span class="grade-badge grade-골드">골드</span>
            <div class="grade-step-desc">15 ~ 29회</div>
          </div>
          <div class="grade-step-arrow">→</div>
          <div class="grade-step ${myInfo.grade == 'VIP' ? 'grade-step-active' : ''}">
            <span class="grade-badge grade-VIP">VIP</span>
            <div class="grade-step-desc">30회 이상</div>
          </div>
        </div>
      </div>

      <!-- 개인 정보 수정 -->
      <div class="glass-card form-card">
        <div class="card-header"><h3>내 정보</h3></div>
        <form action="${pageContext.request.contextPath}/member/updateOk" method="post">
          <input type="hidden" name="m_idx" value="${myInfo.m_idx}">
          <input type="hidden" name="linkedCustomer" value="${myInfo.linkedCustomer}">
          <div class="form-grid">
            <div class="form-group">
              <label for="name">이름</label>
              <input type="text" id="name" name="name" value="${myInfo.name}" required>
            </div>
            <div class="form-group">
              <label>이메일 (변경 불가)</label>
              <input type="email" value="${myInfo.email}" disabled style="opacity:.5">
            </div>
            <div class="form-group">
              <label for="phone">연락처</label>
              <input type="text" id="phone" name="phone" value="${myInfo.phone}" placeholder="010-0000-0000">
            </div>
            <div class="form-group">
              <label for="memo">메모 (알레르기, 선호 음료 등)</label>
              <textarea id="memo" name="memo" rows="3" style="width:100%;padding:8px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.2);border-radius:6px;color:inherit;font-size:14px;resize:vertical">${myInfo.memo}</textarea>
            </div>
          </div>
          <div class="form-actions">
            <button type="submit" class="btn-primary">저장하기</button>
          </div>
        </form>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
<script>
  const d = new Date();
  const el = document.getElementById('sidebar-date');
  if(el) el.textContent = d.getFullYear()+'년 '+(d.getMonth()+1)+'월 '+d.getDate()+'일';

  // 전화번호 자동 하이픈
  document.querySelectorAll('input[name="phone"]').forEach(function(ph) {
    ph.addEventListener('input', function() {
      var v = this.value.replace(/\D/g, '');
      if (v.length <= 3)      this.value = v;
      else if (v.length <= 7) this.value = v.slice(0,3)+'-'+v.slice(3);
      else                    this.value = v.slice(0,3)+'-'+v.slice(3,7)+'-'+v.slice(7,11);
    });
  });
</script>
</body></html>
