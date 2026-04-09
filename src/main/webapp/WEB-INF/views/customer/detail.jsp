<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="고객 상세"/>
<c:set var="activeMenu" value="list"/>
<%@ include file="header.jsp" %>

<style>
  /* ── 방문 기록 폼 ─────────────────────────────────────── */
  .visit-form-row {
    display: flex; align-items: center; gap: 10px; flex-wrap: wrap;
  }
  .visit-amount-input {
    background: var(--bg); border: 1px solid var(--border);
    border-radius: var(--radius-sm); color: var(--text);
    padding: 7px 12px; font-size: 13px; width: 150px;
    transition: border-color 0.2s;
  }
  .visit-amount-input:focus {
    outline: none; border-color: var(--border-hi);
  }
  .visit-amount-input::placeholder { color: var(--text-faint); }

  /* ── 다음 등급 진행 카드 ─────────────────────────────── */
  .tier-progress-card {
    margin-top: 20px;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 22px 24px;
  }
  .tier-progress-title {
    font-family: 'Noto Serif KR', serif;
    font-size: 14px; font-weight: 400;
    color: var(--text); margin-bottom: 18px;
    display: flex; align-items: center; gap: 8px;
  }
  .tier-progress-title .arrow-label {
    font-size: 11px; color: var(--text-faint);
    font-family: 'Noto Sans KR', sans-serif;
  }
  .progress-metric { margin-bottom: 16px; }
  .progress-metric:last-child { margin-bottom: 0; }
  .progress-meta {
    display: flex; justify-content: space-between;
    font-size: 12px; margin-bottom: 6px;
  }
  .progress-meta-key { color: var(--text-dim); }
  .progress-meta-val { color: var(--text); font-weight: 600; }
  .prog-bar-bg {
    height: 8px; background: rgba(255,255,255,0.07);
    border-radius: 4px; overflow: hidden;
  }
  .prog-bar-fill { height: 100%; border-radius: 4px; transition: width 0.8s ease; }
  .progress-hint { font-size: 11px; color: var(--text-faint); margin-top: 4px; }

  .tier-max-badge {
    display: inline-flex; align-items: center; gap: 6px;
    background: rgba(160,80,200,0.15); border: 1px solid rgba(160,80,200,0.35);
    border-radius: 20px; padding: 6px 14px; font-size: 13px; color: #cc88ee;
  }

  .benefit-list {
    display: flex; flex-direction: column; gap: 6px; margin-top: 14px;
    padding-top: 14px; border-top: 1px solid var(--border);
  }
  .benefit-row {
    display: flex; align-items: center; gap: 8px;
    font-size: 12px; color: var(--text-dim);
  }
  .benefit-row .b-icon { font-size: 14px; }
</style>

<div class="glass-card form-card">
    <div class="card-header">
        <h3>${customer.name} 고객 정보</h3>
        <span class="grade-badge grade-${customer.grade}">${customer.grade}</span>
    </div>

    <div class="detail-grid">
        <div class="detail-item">
            <div class="detail-label">이름</div>
            <div class="detail-value">${customer.name}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">연락처</div>
            <div class="detail-value">${customer.phone}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">등급</div>
            <div class="detail-value"><span class="grade-badge grade-${customer.grade}">${customer.grade}</span></div>
        </div>
        <div class="detail-item">
            <div class="detail-label">누적 방문</div>
            <div class="detail-value">${customer.visitCount}회</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">이번 달 방문</div>
            <div class="detail-value">${customer.monthlyVisit}회</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">이번 달 결제액</div>
            <div class="detail-value">
                <fmt:formatNumber value="${customer.monthlyAmount}" pattern="#,###"/>원
            </div>
        </div>
        <div class="detail-item detail-full">
            <div class="detail-label">메모</div>
            <div class="detail-value">${customer.memo}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">생일</div>
            <div class="detail-value">
                <c:choose>
                    <c:when test="${not empty customer.birthday}">${customer.birthday}</c:when>
                    <c:otherwise><span class="td-faint" style="color:var(--text-faint)">-</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="detail-item">
            <div class="detail-label">등록일</div>
            <div class="detail-value td-faint">${customer.regDate}</div>
        </div>
    </div>

    <%-- ── 방문 기록 폼 ─────────────────────────────────── --%>
    <div style="margin-top:20px;padding-top:18px;border-top:1px solid var(--border)">
        <div style="font-size:12px;color:var(--text-faint);margin-bottom:10px">
            방문 결제액을 입력하면 등급이 자동으로 산정됩니다.
        </div>
        <form action="${pageContext.request.contextPath}/customer/addVisit"
              method="post">
            <input type="hidden" name="c_idx"    value="${customer.c_idx}">
            <input type="hidden" name="redirect" value="detail">
            <div class="visit-form-row" style="flex-wrap:wrap;gap:8px;margin-bottom:8px">
                <input type="number" name="amount" min="0" step="100"
                       placeholder="결제액 (원)"
                       class="visit-amount-input">
                <input type="text" name="menuItem" maxlength="200"
                       placeholder="주문 메뉴 (예: 아이스 아메리카노)"
                       class="visit-amount-input" style="width:220px">
                <input type="text" name="note" maxlength="300"
                       placeholder="메모 (선택)"
                       class="visit-amount-input" style="width:200px">
                <button type="submit" class="btn-primary">방문 기록</button>
            </div>
        </form>
    </div>

    <%-- ── 포인트 조정 (회원 연동 계정 보유 고객만 의미 있음) ── --%>
    <div style="margin-top:12px;padding-top:12px;border-top:1px solid var(--border)">
      <form action="${pageContext.request.contextPath}/customer/marketing/adjustPoints"
            method="post" class="visit-form-row">
        <input type="hidden" name="c_idx" value="${customer.c_idx}">
        <input type="number" name="delta" placeholder="포인트 조정 (양수=적립, 음수=차감)"
               class="visit-amount-input" style="width:260px">
        <button type="submit" class="btn-ghost" style="font-size:12px">포인트 조정</button>
      </form>
    </div>

    <div class="form-actions" style="margin-top:16px">
        <a href="${pageContext.request.contextPath}/customer/edit?c_idx=${customer.c_idx}" class="btn-ghost">수정</a>
        <a href="${pageContext.request.contextPath}/customer/list" class="btn-ghost">목록</a>
        <a href="${pageContext.request.contextPath}/customer/delete?c_idx=${customer.c_idx}"
           class="btn-delete-lg"
           onclick="return confirm('${customer.name} 고객을 삭제하시겠습니까?')">삭제</a>
    </div>
</div>

<%-- ══════════════════════════════════════════════════════
     다음 등급까지 진행 현황
     ══════════════════════════════════════════════════════ --%>
<div class="tier-progress-card">

  <c:choose>
    <%-- VIP — 최고 등급 --%>
    <c:when test="${customer.grade == 'VIP'}">
      <div class="tier-progress-title">
        <span class="grade-badge grade-VIP">VIP</span>
        최고 등급 달성
      </div>
      <div class="tier-max-badge">👑 모든 혜택을 누리고 있습니다</div>
      <div class="benefit-list">
        <div class="benefit-row"><span class="b-icon">🎟</span> 모든 음료 쿠폰 월 2장 발급</div>
      </div>
    </c:when>

    <%-- 골드 → VIP --%>
    <c:when test="${customer.grade == '골드'}">
      <div class="tier-progress-title">
        <span class="grade-badge grade-골드">골드</span>
        <span style="color:var(--text-faint);font-size:16px">→</span>
        <span class="grade-badge grade-VIP">VIP</span>
        <span class="arrow-label">다음 등급까지</span>
      </div>
      <c:set var="visitTarget"  value="30"/>
      <c:set var="visitCurrent" value="${customer.monthlyVisit}"/>
      <c:set var="visitPct"     value="${visitCurrent * 100 / visitTarget}"/>
      <c:if test="${visitPct > 100}"><c:set var="visitPct" value="100"/></c:if>
      <c:set var="visitRemain"  value="${visitTarget - visitCurrent}"/>

      <div class="progress-metric">
        <div class="progress-meta">
          <span class="progress-meta-key">📅 이번 달 방문 횟수</span>
          <span class="progress-meta-val">${visitCurrent}회 / ${visitTarget}회</span>
        </div>
        <div class="prog-bar-bg">
          <div class="prog-bar-fill"
               style="width:<fmt:formatNumber value="${visitPct}" maxFractionDigits="1"/>%;
                      background:linear-gradient(90deg,rgba(160,80,200,0.6),rgba(160,80,200,0.9))">
          </div>
        </div>
        <div class="progress-hint">
          <c:choose>
            <c:when test="${visitRemain <= 0}">조건 충족 완료 ✓</c:when>
            <c:otherwise>${visitRemain}회 더 방문하면 VIP 달성</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="benefit-list">
        <div style="font-size:11px;color:var(--text-faint);margin-bottom:4px">현재 골드 혜택</div>
        <div class="benefit-row"><span class="b-icon">☕</span> 무료 아메리카노 쿠폰 월 1장 발급</div>
      </div>
    </c:when>

    <%-- 실버 → 골드 --%>
    <c:when test="${customer.grade == '실버'}">
      <div class="tier-progress-title">
        <span class="grade-badge grade-실버">실버</span>
        <span style="color:var(--text-faint);font-size:16px">→</span>
        <span class="grade-badge grade-골드">골드</span>
        <span class="arrow-label">다음 등급까지</span>
      </div>
      <c:set var="visitTarget"  value="15"/>
      <c:set var="amtTarget"    value="70000"/>
      <c:set var="visitCurrent" value="${customer.monthlyVisit}"/>
      <c:set var="amtCurrent"   value="${customer.monthlyAmount}"/>
      <c:set var="visitPct"     value="${visitCurrent * 100 / visitTarget}"/>
      <c:set var="amtPct"       value="${amtCurrent  * 100 / amtTarget}"/>
      <c:if test="${visitPct > 100}"><c:set var="visitPct" value="100"/></c:if>
      <c:if test="${amtPct   > 100}"><c:set var="amtPct"   value="100"/></c:if>

      <div class="progress-metric">
        <div class="progress-meta">
          <span class="progress-meta-key">📅 이번 달 방문 횟수</span>
          <span class="progress-meta-val">${visitCurrent}회 / ${visitTarget}회</span>
        </div>
        <div class="prog-bar-bg">
          <div class="prog-bar-fill"
               style="width:<fmt:formatNumber value="${visitPct}" maxFractionDigits="1"/>%;
                      background:linear-gradient(90deg,rgba(176,125,82,0.5),rgba(200,131,42,0.85))">
          </div>
        </div>
        <div class="progress-hint">
          <c:choose>
            <c:when test="${visitCurrent >= visitTarget}">조건 충족 완료 ✓</c:when>
            <c:otherwise>${visitTarget - visitCurrent}회 더 방문하면 골드 달성 가능</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="progress-metric">
        <div class="progress-meta">
          <span class="progress-meta-key">💳 이번 달 결제액</span>
          <span class="progress-meta-val">
            <fmt:formatNumber value="${amtCurrent}" pattern="#,###"/>원
            / <fmt:formatNumber value="${amtTarget}" pattern="#,###"/>원
          </span>
        </div>
        <div class="prog-bar-bg">
          <div class="prog-bar-fill"
               style="width:<fmt:formatNumber value="${amtPct}" maxFractionDigits="1"/>%;
                      background:linear-gradient(90deg,rgba(176,125,82,0.5),rgba(200,131,42,0.85))">
          </div>
        </div>
        <div class="progress-hint">
          <c:choose>
            <c:when test="${amtCurrent >= amtTarget}">조건 충족 완료 ✓</c:when>
            <c:otherwise>
              <fmt:formatNumber value="${amtTarget - amtCurrent}" pattern="#,###"/>원 더 결제하면 골드 달성 가능
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div style="font-size:11px;color:var(--text-faint);margin-top:4px">* 두 조건 중 하나만 충족해도 골드로 승급됩니다.</div>

      <div class="benefit-list">
        <div style="font-size:11px;color:var(--text-faint);margin-bottom:4px">현재 실버 혜택</div>
        <div class="benefit-row"><span class="b-icon">🎟</span> 사이즈업 쿠폰 월 1장 발급</div>
      </div>
    </c:when>

    <%-- 일반 → 실버 --%>
    <c:otherwise>
      <div class="tier-progress-title">
        <span class="grade-badge grade-일반">일반</span>
        <span style="color:var(--text-faint);font-size:16px">→</span>
        <span class="grade-badge grade-실버">실버</span>
        <span class="arrow-label">다음 등급까지</span>
      </div>
      <c:set var="visitTarget"  value="5"/>
      <c:set var="amtTarget"    value="30000"/>
      <c:set var="visitCurrent" value="${customer.monthlyVisit}"/>
      <c:set var="amtCurrent"   value="${customer.monthlyAmount}"/>
      <c:set var="visitPct"     value="${visitCurrent * 100 / visitTarget}"/>
      <c:set var="amtPct"       value="${amtCurrent  * 100 / amtTarget}"/>
      <c:if test="${visitPct > 100}"><c:set var="visitPct" value="100"/></c:if>
      <c:if test="${amtPct   > 100}"><c:set var="amtPct"   value="100"/></c:if>

      <div class="progress-metric">
        <div class="progress-meta">
          <span class="progress-meta-key">📅 이번 달 방문 횟수</span>
          <span class="progress-meta-val">${visitCurrent}회 / ${visitTarget}회</span>
        </div>
        <div class="prog-bar-bg">
          <div class="prog-bar-fill"
               style="width:<fmt:formatNumber value="${visitPct}" maxFractionDigits="1"/>%;
                      background:linear-gradient(90deg,rgba(192,192,192,0.4),rgba(192,192,192,0.75))">
          </div>
        </div>
        <div class="progress-hint">
          <c:choose>
            <c:when test="${visitCurrent >= visitTarget}">조건 충족 완료 ✓</c:when>
            <c:otherwise>${visitTarget - visitCurrent}회 더 방문하면 실버 달성 가능</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="progress-metric">
        <div class="progress-meta">
          <span class="progress-meta-key">💳 이번 달 결제액</span>
          <span class="progress-meta-val">
            <fmt:formatNumber value="${amtCurrent}" pattern="#,###"/>원
            / <fmt:formatNumber value="${amtTarget}" pattern="#,###"/>원
          </span>
        </div>
        <div class="prog-bar-bg">
          <div class="prog-bar-fill"
               style="width:<fmt:formatNumber value="${amtPct}" maxFractionDigits="1"/>%;
                      background:linear-gradient(90deg,rgba(192,192,192,0.4),rgba(192,192,192,0.75))">
          </div>
        </div>
        <div class="progress-hint">
          <c:choose>
            <c:when test="${amtCurrent >= amtTarget}">조건 충족 완료 ✓</c:when>
            <c:otherwise>
              <fmt:formatNumber value="${amtTarget - amtCurrent}" pattern="#,###"/>원 더 결제하면 실버 달성 가능
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div style="font-size:11px;color:var(--text-faint);margin-top:4px">* 두 조건 중 하나만 충족해도 실버로 승급됩니다.</div>

      <div class="benefit-list">
        <div style="font-size:11px;color:var(--text-faint);margin-bottom:4px">현재 일반 혜택</div>
        <div class="benefit-row"><span class="b-icon">🎁</span> 가입 축하 아메리카노 쿠폰 1장 발급</div>
      </div>
    </c:otherwise>
  </c:choose>

</div>

<%-- ══════════════════════════════════════════════════════
     보유 쿠폰
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" id="coupons" style="margin-top:18px">
  <div class="card-header"><h3>보유 쿠폰</h3></div>
  <c:choose>
    <c:when test="${empty customerCoupons}">
      <div class="empty-msg" style="padding:20px 0">발급된 쿠폰이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <table class="crm-table">
        <thead>
          <tr>
            <th>쿠폰명</th>
            <th style="width:90px">종류</th>
            <th style="width:110px">만료일</th>
            <th style="width:80px">상태</th>
            <th style="width:90px">처리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="cp" items="${customerCoupons}">
            <tr style="${cp.used == 1 ? 'opacity:0.45' : ''}">
              <td>${cp.coupon_name}</td>
              <td>
                <c:choose>
                  <c:when test="${cp.coupon_type == 'FREE'}">무료음료</c:when>
                  <c:when test="${cp.coupon_type == 'DISCOUNT'}">할인</c:when>
                  <c:when test="${cp.coupon_type == 'UPGRADE'}">업그레이드</c:when>
                  <c:otherwise>${cp.coupon_type}</c:otherwise>
                </c:choose>
              </td>
              <td class="td-faint">${cp.expire_date}</td>
              <td>
                <c:choose>
                  <c:when test="${cp.used == 1}">
                    <span style="color:var(--text-faint)">사용완료</span>
                  </c:when>
                  <c:otherwise>
                    <span style="color:var(--brown-hi);font-weight:600">미사용</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:if test="${cp.used == 0}">
                  <form action="${pageContext.request.contextPath}/customer/marketing/useCoupon"
                        method="post" style="margin:0">
                    <input type="hidden" name="cc_idx" value="${cp.cc_idx}">
                    <input type="hidden" name="c_idx"  value="${customer.c_idx}">
                    <button type="submit" class="btn-ghost"
                            style="font-size:11px;padding:4px 10px"
                            onclick="return confirm('쿠폰을 사용 처리하시겠습니까?')">사용처리</button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<%-- ══════════════════════════════════════════════════════
     특이사항 태그
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" id="tags" style="margin-top:18px">
  <div class="card-header"><h3>특이사항 태그</h3></div>

  <%-- 기존 태그 목록 --%>
  <div style="display:flex;flex-wrap:wrap;gap:8px;margin-bottom:16px;min-height:32px">
    <c:choose>
      <c:when test="${empty tags}">
        <span style="font-size:12px;color:var(--text-faint)">등록된 태그가 없습니다.</span>
      </c:when>
      <c:otherwise>
        <c:forEach var="t" items="${tags}">
          <span class="tag-chip">
            ${t}
            <form action="${pageContext.request.contextPath}/customer/deleteTag"
                  method="post" style="display:inline">
              <input type="hidden" name="c_idx" value="${customer.c_idx}">
              <input type="hidden" name="tag"   value="${t}">
              <button type="submit" class="tag-del-btn" title="삭제">✕</button>
            </form>
          </span>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- 태그 추가 폼 --%>
  <form action="${pageContext.request.contextPath}/customer/addTag"
        method="post" style="display:flex;gap:8px;align-items:center">
    <input type="hidden" name="c_idx" value="${customer.c_idx}">
    <input type="text" name="tag" maxlength="50"
           placeholder="태그 입력 (예: 우유 알레르기)"
           style="flex:1;max-width:300px;background:var(--bg);border:1px solid var(--border);
                  border-radius:var(--radius-sm);color:var(--text);padding:7px 12px;font-size:13px">
    <button type="submit" class="btn-ghost" style="font-size:12px">+ 추가</button>
  </form>
</div>

<%-- ══════════════════════════════════════════════════════
     방문 이력
     ══════════════════════════════════════════════════════ --%>
<div class="glass-card" style="margin-top:18px">
  <div class="card-header"><h3>방문 이력 <span style="font-size:11px;color:var(--text-faint);font-weight:400">(최근 20건)</span></h3></div>
  <c:choose>
    <c:when test="${empty visitLogs}">
      <div class="empty-msg" style="padding:20px 0">방문 기록이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <table class="crm-table">
        <thead>
          <tr>
            <th style="width:160px">방문 일시</th>
            <th>주문 메뉴</th>
            <th style="width:110px;text-align:right">결제액</th>
            <th>메모</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="v" items="${visitLogs}">
            <tr>
              <td class="td-faint">${v.regDate}</td>
              <td>${empty v.menuItem ? '-' : v.menuItem}</td>
              <td style="text-align:right">
                <c:choose>
                  <c:when test="${v.amount > 0}">
                    <fmt:formatNumber value="${v.amount}" pattern="#,###"/>원
                  </c:when>
                  <c:otherwise><span class="td-faint">-</span></c:otherwise>
                </c:choose>
              </td>
              <td class="td-faint">${empty v.note ? '' : v.note}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<style>
  .tag-chip {
    display: inline-flex; align-items: center; gap: 6px;
    background: rgba(176,125,82,0.15); border: 1px solid var(--border-hi);
    border-radius: 20px; padding: 4px 10px 4px 12px;
    font-size: 12px; color: var(--brown-hi);
  }
  .tag-del-btn {
    background: none; border: none; cursor: pointer;
    color: var(--text-faint); font-size: 11px; padding: 0;
    line-height: 1; transition: color .2s;
  }
  .tag-del-btn:hover { color: #e06060; }
</style>

<%@ include file="footer.jsp" %>
