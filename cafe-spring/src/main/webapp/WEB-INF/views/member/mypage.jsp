<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="마이페이지 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage-theme.css">

<div class="mp-page">

  <%-- ── 프로필 배너 ── --%>
  <div class="mp-banner">
    <div class="mp-banner__avatar">
      ${fn:substring(member.m_name, 0, 1)}
    </div>
    <div class="mp-banner__name">${member.m_name}</div>
    <div class="mp-banner__id">@${member.m_id}</div>
    <div class="mp-banner__deco">
      <div class="mp-banner__deco-line"></div>
      <div class="mp-banner__deco-dot"></div>
      <div class="mp-banner__deco-line"></div>
    </div>
  </div>

  <%-- ── 본문 ── --%>
  <div class="mp-body">

    <%-- 알림 메시지 --%>
    <c:if test="${not empty successMsg}">
      <div class="mp-alert mp-alert--success">✔ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
      <div class="mp-alert mp-alert--error">✖ ${errorMsg}</div>
    </c:if>

    <%-- ── 탭 네비게이션 ── --%>
    <div class="mp-tabs">
      <button class="mp-tab-btn" data-tab="info"    onclick="showTab('info')">기본 정보</button>
      <button class="mp-tab-btn" data-tab="security" onclick="showTab('security')">보안 설정</button>
      <button class="mp-tab-btn" data-tab="posts"   onclick="showTab('posts')">내가 쓴 글</button>
      <button class="mp-tab-btn" data-tab="account" onclick="showTab('account')">계정 관리</button>
    </div>

    <%-- ════════════════ 탭 1: 기본 정보 ════════════════ --%>
    <div id="tab-info" class="mp-panel">

      <%-- 정보 요약 카드 --%>
      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">👤</span> 현재 정보
        </div>
        <div class="mp-info-row">
          <span class="mp-info-label">아이디</span>
          <span class="mp-info-value">${member.m_id}</span>
        </div>
        <div class="mp-info-row">
          <span class="mp-info-label">이름</span>
          <span class="mp-info-value">${member.m_name}</span>
        </div>
        <div class="mp-info-row">
          <span class="mp-info-label">전화번호</span>
          <span class="mp-info-value">
            <c:choose>
              <c:when test="${not empty member.m_phone}">${member.m_phone}</c:when>
              <c:otherwise><span style="color:var(--rown-muted)">미입력</span></c:otherwise>
            </c:choose>
          </span>
        </div>
        <div class="mp-info-row">
          <span class="mp-info-label">이메일</span>
          <span class="mp-info-value">
            <c:choose>
              <c:when test="${not empty member.m_email}">${member.m_email}</c:when>
              <c:otherwise><span style="color:var(--rown-muted)">미입력</span></c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>

      <%-- 수정 폼 카드 --%>
      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">✏</span> 정보 수정
        </div>
        <form action="${pageContext.request.contextPath}/member/updateInfo" method="post">
          <div class="mp-form-group">
            <label class="mp-label">아이디 <span style="color:var(--rown-muted);font-weight:400">(변경 불가)</span></label>
            <input type="text" class="mp-input" value="${member.m_id}" readonly>
          </div>
          <div class="mp-form-group">
            <label class="mp-label">이름 <span style="color:#c0392b">*</span></label>
            <input type="text" name="m_name" class="mp-input"
                   value="${member.m_name}" placeholder="이름을 입력하세요" required>
          </div>
          <div class="mp-form-group">
            <label class="mp-label">전화번호</label>
            <input type="tel" name="m_phone" class="mp-input"
                   value="${member.m_phone}" placeholder="010-0000-0000">
          </div>
          <div class="mp-form-group">
            <label class="mp-label">이메일</label>
            <input type="email" name="m_email" class="mp-input"
                   value="${member.m_email}" placeholder="example@email.com">
          </div>
          <div style="display:flex; justify-content:flex-end; margin-top:1.5rem;">
            <button type="submit" class="mp-btn mp-btn--primary">저장하기</button>
          </div>
        </form>
      </div>

    </div><%-- /tab-info --%>

    <%-- ════════════════ 탭 2: 보안 설정 ════════════════ --%>
    <div id="tab-security" class="mp-panel">
      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">🔒</span> 비밀번호 변경
        </div>
        <form action="${pageContext.request.contextPath}/member/changePw" method="post">
          <div class="mp-form-group">
            <label class="mp-label">현재 비밀번호 <span style="color:#c0392b">*</span></label>
            <input type="password" name="currentPw" class="mp-input"
                   placeholder="현재 비밀번호를 입력하세요" required>
          </div>
          <div class="mp-form-group">
            <label class="mp-label">새 비밀번호 <span style="color:#c0392b">*</span></label>
            <input type="password" name="newPw" id="newPw" class="mp-input"
                   placeholder="새 비밀번호 (4자 이상)" required minlength="4">
          </div>
          <div class="mp-form-group">
            <label class="mp-label">새 비밀번호 확인 <span style="color:#c0392b">*</span></label>
            <input type="password" name="confirmPw" id="confirmPw" class="mp-input"
                   placeholder="새 비밀번호를 다시 입력하세요" required>
            <div id="pw-match-msg" class="mp-input-hint"></div>
          </div>
          <div style="display:flex; justify-content:flex-end; margin-top:1.5rem;">
            <button type="submit" class="mp-btn mp-btn--primary">비밀번호 변경</button>
          </div>
        </form>
      </div>
    </div><%-- /tab-security --%>

    <%-- ════════════════ 탭 3: 내가 쓴 글 ════════════════ --%>
    <div id="tab-posts" class="mp-panel">
      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">📝</span>
          내가 쓴 글
          <span style="font-size:.8rem; color:var(--rown-muted); font-family:var(--font-sans); font-weight:400; margin-left:.3rem;">
            (최근 10개)
          </span>
        </div>

        <c:choose>
          <c:when test="${empty myPosts}">
            <div class="mp-post-empty">
              <div class="mp-post-empty-icon">📋</div>
              <div>아직 작성한 글이 없습니다.</div>
              <div style="margin-top:.5rem; font-size:.8rem;">
                <a href="${pageContext.request.contextPath}/board/write"
                   style="color:var(--rown-gold2); font-weight:600; text-decoration:none;">
                  첫 글 작성하러 가기 →
                </a>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <ul class="mp-post-list">
              <c:forEach var="p" items="${myPosts}">
                <li class="mp-post-item">
                  <span class="mp-post-badge">${p.category}</span>
                  <a href="${pageContext.request.contextPath}/board/detail?b_idx=${p.b_idx}"
                     class="mp-post-title" title="${p.title}">${p.title}</a>
                  <span class="mp-post-date">${p.regDate}</span>
                </li>
              </c:forEach>
            </ul>
            <div style="text-align:right; margin-top:1rem;">
              <a href="${pageContext.request.contextPath}/board/list?keyword=${member.m_id}"
                 style="font-size:.8rem; color:var(--rown-gold2); text-decoration:none; font-weight:600;">
                전체 보기 →
              </a>
            </div>
          </c:otherwise>
        </c:choose>

      </div>
    </div><%-- /tab-posts --%>

    <%-- ════════════════ 탭 4: 계정 관리 ════════════════ --%>
    <div id="tab-account" class="mp-panel">
      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">⚙</span> 계정 관리
        </div>

        <%-- 로그아웃 --%>
        <div style="display:flex; justify-content:space-between; align-items:center;
                    padding: .75rem 0; border-bottom: 1px solid var(--rown-beige);">
          <div>
            <div style="font-size:.9rem; font-weight:600; color:var(--rown-text);">로그아웃</div>
            <div style="font-size:.8rem; color:var(--rown-muted); margin-top:.2rem;">현재 기기에서 로그아웃합니다.</div>
          </div>
          <a href="${pageContext.request.contextPath}/member/logout"
             class="mp-btn mp-btn--outline" style="font-size:.8rem; padding:.5rem 1.2rem;">
            로그아웃
          </a>
        </div>

        <%-- 마이페이지 재인증 초기화 --%>
        <div style="display:flex; justify-content:space-between; align-items:center;
                    padding: .75rem 0; border-bottom: 1px solid var(--rown-beige);">
          <div>
            <div style="font-size:.9rem; font-weight:600; color:var(--rown-text);">보안 잠금</div>
            <div style="font-size:.8rem; color:var(--rown-muted); margin-top:.2rem;">마이페이지 인증을 초기화하여 다음 접근 시 비밀번호를 다시 확인합니다.</div>
          </div>
          <a href="${pageContext.request.contextPath}/member/mypageLock"
             class="mp-btn mp-btn--outline" style="font-size:.8rem; padding:.5rem 1.2rem;">
            잠금
          </a>
        </div>

      </div>

      <%-- 회원 탈퇴 --%>
      <div class="mp-danger-box">
        <div class="mp-danger-box__title">⚠ 회원 탈퇴</div>
        <div class="mp-danger-box__desc">
          탈퇴 전 아래 내용을 반드시 확인해 주세요.
        </div>
        <ul>
          <li>탈퇴 즉시 계정 정보가 영구적으로 삭제됩니다.</li>
          <li>작성한 게시글 및 댓글은 삭제되지 않을 수 있습니다.</li>
          <li>동일한 아이디로 재가입이 가능합니다.</li>
        </ul>
        <form action="${pageContext.request.contextPath}/member/withdraw" method="post"
              onsubmit="return confirmWithdraw()">
          <div class="mp-form-group">
            <label class="mp-label">비밀번호 확인 <span style="color:#c0392b">*</span></label>
            <input type="password" name="withdrawPw" class="mp-input"
                   placeholder="탈퇴를 위해 비밀번호를 입력하세요" required>
          </div>
          <button type="submit" class="mp-btn mp-btn--danger" style="margin-top:.5rem;">
            회원 탈퇴
          </button>
        </form>
      </div>

    </div><%-- /tab-account --%>

  </div><%-- /mp-body --%>
</div><%-- /mp-page --%>

<script>
  /* ── 탭 전환 ── */
  function showTab(name) {
    document.querySelectorAll('.mp-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.mp-tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + name).classList.add('active');
    document.querySelector('[data-tab="' + name + '"]').classList.add('active');
  }

  /* ── 초기 탭 설정 (서버에서 flashAttribute 로 넘겨줌) ── */
  const initialTab = "${not empty activeTab ? activeTab : 'info'}";
  showTab(initialTab);

  /* ── 비밀번호 일치 실시간 검사 ── */
  const newPwEl     = document.getElementById('newPw');
  const confirmPwEl = document.getElementById('confirmPw');
  const matchMsg    = document.getElementById('pw-match-msg');

  function checkPwMatch() {
    if (!confirmPwEl.value) { matchMsg.textContent = ''; return; }
    if (newPwEl.value === confirmPwEl.value) {
      matchMsg.textContent = '✔ 비밀번호가 일치합니다.';
      matchMsg.style.color = '#16a34a';
    } else {
      matchMsg.textContent = '✖ 비밀번호가 일치하지 않습니다.';
      matchMsg.style.color = '#dc2626';
    }
  }
  if (newPwEl) {
    newPwEl.addEventListener('input', checkPwMatch);
    confirmPwEl.addEventListener('input', checkPwMatch);
  }

  /* ── 회원 탈퇴 확인 ── */
  function confirmWithdraw() {
    return confirm('정말로 탈퇴하시겠습니까?\n탈퇴 후에는 계정 정보가 영구 삭제됩니다.');
  }
</script>

<%@ include file="../common/footer.jsp" %>
