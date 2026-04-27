<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
      <button class="mp-tab-btn" data-tab="points"  onclick="showTab('points')">포인트</button>
      <button class="mp-tab-btn" data-tab="security" onclick="showTab('security')">보안 설정</button>
      <button class="mp-tab-btn" data-tab="posts"   onclick="showTab('posts')">내가 쓴 글</button>
      <button class="mp-tab-btn" data-tab="orders"  onclick="showTab('orders')">내 주문 내역</button>
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

    <%-- ════════════════ 탭 2: 포인트 ════════════════ --%>
    <div id="tab-points" class="mp-panel">
      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">💰</span> 보유 포인트
        </div>
        <div class="mp-points-balance">
          <span class="mp-points-balance__num">
            <fmt:formatNumber value="${pointBalance != null ? pointBalance : 0}" pattern="#,##0"/>
          </span>
          <span class="mp-points-balance__unit">P</span>
        </div>
        <div class="mp-points-policy">
          <ul>
            <li>적립률: 일반 3% / 실버 5% / 골드 7% / VIP 10%</li>
            <li>1P = 1원, 1,000P부터 100P 단위 사용</li>
            <li>주문 취소 시 적립은 환불율만큼 회수, 사용은 환불율만큼 복원</li>
          </ul>
        </div>
      </div>

      <div class="mp-card">
        <div class="mp-card__title">
          <span class="mp-card__title-icon">📒</span> 포인트 내역
          <span style="font-size:.8rem; color:var(--rown-muted); font-family:var(--font-sans); font-weight:400; margin-left:.3rem;">
            (최근 10건 / 전체 ${pointHistoryCount}건)
          </span>
        </div>
        <c:choose>
          <c:when test="${empty pointHistory}">
            <div class="mp-post-empty">
              <div class="mp-post-empty-icon">🪙</div>
              <div>아직 포인트 내역이 없습니다.</div>
            </div>
          </c:when>
          <c:otherwise>
            <table class="mp-point-table">
              <thead>
                <tr>
                  <th>일시</th>
                  <th>구분</th>
                  <th class="mp-point-amount">변동</th>
                  <th class="mp-point-amount">잔액</th>
                  <th>비고</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="h" items="${pointHistory}">
                  <c:set var="typeLabel" value="${h.type}"/>
                  <c:if test="${h.type == 'EARN'}">         <c:set var="typeLabel" value="적립"/></c:if>
                  <c:if test="${h.type == 'USE'}">          <c:set var="typeLabel" value="사용"/></c:if>
                  <c:if test="${h.type == 'CANCEL_EARN'}">  <c:set var="typeLabel" value="적립취소"/></c:if>
                  <c:if test="${h.type == 'RESTORE_USE'}">  <c:set var="typeLabel" value="사용복원"/></c:if>
                  <c:if test="${h.type == 'SIGNUP_BONUS'}"> <c:set var="typeLabel" value="가입축하"/></c:if>
                  <tr>
                    <td>${fn:replace(fn:substring(h.regDate, 0, 16), 'T', ' ')}</td>
                    <td>${typeLabel}</td>
                    <td class="mp-point-amount mp-point-amount--${h.amount >= 0 ? 'plus' : 'minus'}">
                      ${h.amount >= 0 ? '+' : ''}<fmt:formatNumber value="${h.amount}" pattern="#,##0"/>P
                    </td>
                    <td class="mp-point-amount">
                      <fmt:formatNumber value="${h.balanceAfter}" pattern="#,##0"/>P
                    </td>
                    <td>${h.description}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div><%-- /tab-points --%>

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

    <%-- ════════════════ 탭 4: 내 주문 내역 ════════════════ --%>
    <div id="tab-orders" class="mp-panel">
      <div class="mp-card">
        <div class="mp-card__title">
          내 주문 내역
          <span style="font-size:.8rem; color:var(--rown-muted); font-family:var(--font-sans); font-weight:400; margin-left:.3rem;">
            (최근 20건)
          </span>
        </div>

        <c:choose>
          <c:when test="${empty myOrders}">
            <div class="mp-post-empty">
              <div class="mp-post-empty-icon">🧾</div>
              <div>아직 주문 내역이 없습니다.</div>
              <div style="margin-top:.5rem; font-size:.8rem;">
                <a href="${pageContext.request.contextPath}/menu/list"
                   style="color:var(--rown-gold2); font-weight:600; text-decoration:none;">
                  메뉴 보러 가기 →
                </a>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <table class="mp-order-table">
              <thead>
                <tr>
                  <th>주문일시</th>
                  <th>메뉴</th>
                  <th>총액</th>
                  <th>상태</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="o" items="${myOrders}">
                  <tr class="mp-order-row" onclick="openOrderDetail('${o.orderId}')">
                    <td>${fn:replace(fn:substring(o.regDate, 0, 16), 'T', ' ')}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty o.firstMenuName}">
                          ${o.firstMenuName}
                          <c:if test="${o.itemCount > 1}"> 외 ${o.itemCount - 1}건</c:if>
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </td>
                    <td>${o.totalAmount}원</td>
                    <td><span class="mp-order-status mp-order-status--${fn:toLowerCase(o.status)}">${o.status}</span></td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div><%-- /tab-orders --%>

    <%-- ════════════════ 탭 5: 계정 관리 ════════════════ --%>
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
              data-confirm="정말로 탈퇴하시겠습니까? 탈퇴 후에는 계정 정보가 영구 삭제됩니다."
              data-confirm-title="회원 탈퇴 확인"
              data-confirm-text="탈퇴"
              data-confirm-danger>
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

  /* 회원 탈퇴 확인은 form 의 data-confirm 속성으로 ui-dialog.js 가 처리 */
</script>

<%-- ════════ 주문 상세 모달 ════════ --%>
<div id="order-detail-modal" class="od-overlay" onclick="closeOrderDetail()">
  <div class="od-modal" onclick="event.stopPropagation()">
    <div class="od-modal__header">
      <div class="od-modal__title">주문 상세</div>
      <button class="od-modal__close" onclick="closeOrderDetail()">✕</button>
    </div>
    <div id="od-modal-body" class="od-modal__body">
      <div class="od-info-grid">
        <span class="od-label">주문번호</span><span id="od-order-id" class="od-value"></span>
        <span class="od-label">주문일시</span><span id="od-reg-date" class="od-value"></span>
        <span class="od-label">결제일시</span><span id="od-paid-date" class="od-value"></span>
        <span class="od-label">상태</span><span id="od-status" class="od-value"></span>
        <span class="od-label">결제키</span><span id="od-payment-key" class="od-value od-mono"></span>
        <span class="od-label">총액</span><span id="od-total" class="od-value od-total-val"></span>
      </div>
      <table class="od-item-table">
        <thead>
          <tr><th>메뉴명</th><th>온도</th><th>사이즈</th><th>수량</th><th>단가</th><th>소계</th></tr>
        </thead>
        <tbody id="od-item-tbody"></tbody>
      </table>

      <%-- ── 이미 취소된 주문: 취소 정보 표시 ── --%>
      <div id="canceled-info" class="canceled-info" style="display:none">
        <strong>🚫 취소된 주문</strong>
        <div class="canceled-info__grid">
          <span>취소 사유</span><span id="ci-reason">—</span>
          <span>취소 일시</span><span id="ci-date">—</span>
          <span>환불 금액</span><span id="ci-amount">—</span>
          <span>비고</span><span id="ci-memo">—</span>
        </div>
      </div>

      <%-- ── PAID 상태: 취소 UI ── --%>
      <div id="cancel-section" class="cancel-section" style="display:none">
        <div class="cancel-policy">
          <strong>📋 취소 및 환불 안내</strong>
          <ul>
            <li>3분 이내: 전액 환불 (100%)</li>
            <li>3 ~ 10분: 부분 환불 (50%)</li>
            <li>10분 초과: 취소 불가</li>
          </ul>
          <p class="refund-notice">
            * 카드사 정책에 따라 영업일 기준 2~5일 소요<br>
            * 한 번 취소된 주문은 복원 불가
          </p>
          <p class="refund-notice" style="margin-top:8px">
            ℹ️ 환불 금액은 <strong>"주문 취소" 버튼을 누르는 순간</strong>을 기준으로 확정됩니다.<br>
            시간이 지나면 환불 비율이 달라질 수 있습니다.
          </p>
        </div>

        <div id="refund-preview-row" class="current-refund-info">
          현재 취소 시 환불 금액: <strong id="refund-preview">—</strong>
        </div>

        <div id="refund-too-late" class="refund-too-late" style="display:none">
          ⏱ 취소 가능 시간이 지났습니다.
        </div>

        <div id="cancel-form" style="display:none">
          <label for="cancel-reason">취소 사유 <span class="required">*</span></label>
          <select id="cancel-reason" required>
            <option value="">선택해주세요</option>
            <option value="CHANGE_MIND">단순 변심</option>
            <option value="WRONG_ORDER">주문 실수</option>
            <option value="TOO_SLOW">조리 지연</option>
            <option value="ETC">기타</option>
          </select>

          <textarea id="cancel-memo" placeholder="상세 사유 (기타 선택 시 필수)" rows="2"
                    maxlength="200" style="display:none"></textarea>

          <button type="button" class="btn-cancel-order" onclick="cancelOrder()">
            주문 취소
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>window.ctxPath = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/resources/js/my-orders.js"></script>
<%@ include file="../common/footer.jsp" %>
