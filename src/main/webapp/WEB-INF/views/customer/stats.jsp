<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"     prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"      prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle"  value="통계"/>
<c:set var="activeMenu" value="stats"/>
<%@ include file="header.jsp" %>

<style>
  /* ── 통계 전용 로컬 스타일 ─────────────────────────── */
  .section-label {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--brown-hi);
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .section-label::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border);
  }

  /* 요약 카드 */
  .kpi-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 14px;
    margin-bottom: 28px;
  }
  .kpi-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 20px 22px;
    box-shadow: var(--shadow);
    transition: var(--transition);
    display: flex;
    align-items: center;
    gap: 16px;
  }
  .kpi-card:hover { background: var(--bg-hover); border-color: var(--border-hi); transform: translateY(-2px); }
  .kpi-icon {
    width: 44px; height: 44px;
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 20px;
    flex-shrink: 0;
  }
  .kpi-body { display: flex; flex-direction: column; gap: 2px; }
  .kpi-label { font-size: 11px; color: var(--text-dim); letter-spacing: 0.04em; }
  .kpi-value { font-size: 22px; font-weight: 700; line-height: 1.1; color: var(--text); }

  /* 등급 기준 카드 */
  .tier-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
    margin-bottom: 28px;
  }
  .tier-card {
    border-radius: var(--radius);
    padding: 18px 18px 16px;
    border: 1px solid;
    position: relative;
    overflow: hidden;
  }
  .tier-card::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 3px;
  }
  .tier-일반 { background: rgba(240,224,200,0.05); border-color: var(--border); }
  .tier-일반::before { background: rgba(240,224,200,0.3); }
  .tier-실버 { background: rgba(192,192,192,0.07); border-color: rgba(192,192,192,0.25); }
  .tier-실버::before { background: linear-gradient(90deg, #aaa, #ddd, #aaa); }
  .tier-골드 { background: rgba(176,125,82,0.09); border-color: var(--border-hi); }
  .tier-골드::before { background: linear-gradient(90deg, #8B5E3C, #C9935F, #8B5E3C); }
  .tier-VIP  { background: rgba(160,80,200,0.10); border-color: rgba(160,80,200,0.32); }
  .tier-VIP::before  { background: linear-gradient(90deg, #7e34a8, #cc88ee, #7e34a8); }

  .tier-name { font-size: 15px; font-weight: 700; margin-bottom: 10px; }
  .tier-일반 .tier-name { color: var(--text-dim); }
  .tier-실버 .tier-name { color: #ccc; }
  .tier-골드 .tier-name { color: var(--brown-hi); }
  .tier-VIP  .tier-name { color: #cc88ee; }

  .tier-row { display: flex; justify-content: space-between; align-items: center;
    font-size: 12px; padding: 5px 0; border-bottom: 1px solid rgba(255,255,255,0.05); }
  .tier-row:last-child { border-bottom: none; }
  .tier-row-key { color: var(--text-faint); }
  .tier-row-val { font-weight: 600; color: var(--text-dim); }

  .tier-arrow {
    display: flex; align-items: center; justify-content: center;
    color: var(--text-faint); font-size: 18px; padding-top: 24px;
  }

  /* 차트 패널 */
  .chart-panel {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 22px 22px 18px;
    box-shadow: var(--shadow);
  }
  .chart-title {
    font-family: 'Noto Serif KR', serif;
    font-size: 14px;
    font-weight: 400;
    color: var(--text);
    margin-bottom: 16px;
    display: flex;
    align-items: baseline;
    gap: 8px;
  }
  .chart-title-sub {
    font-size: 11px;
    color: var(--text-faint);
    font-family: 'Noto Sans KR', sans-serif;
  }

  /* 도넛 범례 */
  .donut-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
  }
  .legend-list { list-style: none; padding: 0; margin: 0; width: 100%; display: flex; flex-direction: column; gap: 7px; }
  .legend-row {
    display: flex; justify-content: space-between; align-items: center;
    font-size: 13px; padding: 5px 8px; border-radius: 6px;
    transition: background 0.15s;
  }
  .legend-row:hover { background: var(--cream-faint); }
  .legend-dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; margin-right: 8px; }
  .legend-label { display: flex; align-items: center; }
  .legend-count { color: var(--text-dim); font-size: 12px; }

  /* 테이블 */
  .rank-no { font-weight: 700; color: var(--brown-hi); width: 40px; text-align: center; }
  .rank-1  { color: #cc88ee; }
  .rank-2  { color: var(--brown-hi); }
  .rank-3  { color: #ccc; }
  .progress-bar-wrap { display: flex; align-items: center; gap: 8px; min-width: 120px; }
  .progress-bar-bg { flex: 1; height: 6px; background: rgba(255,255,255,0.08); border-radius: 3px; overflow: hidden; }
  .progress-bar-fill { height: 100%; border-radius: 3px; }
</style>

<%-- ══════════════════════════════════════════════════════
     KPI 요약 카드
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">핵심 지표</div>
<div class="kpi-grid" style="margin-bottom:28px">

  <div class="kpi-card">
    <div class="kpi-icon" style="background:rgba(176,125,82,0.18)">☕</div>
    <div class="kpi-body">
      <span class="kpi-label">전체 고객</span>
      <span class="kpi-value">${totalCount}<span style="font-size:13px;font-weight:400;color:var(--text-dim)">명</span></span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon" style="background:rgba(160,80,200,0.18)">👑</div>
    <div class="kpi-body">
      <span class="kpi-label">VIP 고객</span>
      <span class="kpi-value" style="color:#cc88ee">${vipCount}<span style="font-size:13px;font-weight:400;color:rgba(204,136,238,0.6)">명</span></span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon" style="background:rgba(127,214,127,0.14)">✨</div>
    <div class="kpi-body">
      <span class="kpi-label">이번 달 신규</span>
      <span class="kpi-value" style="color:rgba(127,214,127,0.9)">${newCount}<span style="font-size:13px;font-weight:400;color:rgba(127,214,127,0.45)">명</span></span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon" style="background:rgba(100,160,220,0.15)">📊</div>
    <div class="kpi-body">
      <span class="kpi-label">평균 방문 횟수</span>
      <span class="kpi-value" style="color:rgba(130,180,240,0.9)">${avgVisit}<span style="font-size:13px;font-weight:400;color:rgba(130,180,240,0.45)">회</span></span>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════
     멤버십 등급 기준
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">멤버십 등급 기준 <span style="font-weight:400;text-transform:none;letter-spacing:0;color:var(--text-faint)">(이번 달 방문 횟수 또는 결제액 기준, 매월 산정)</span></div>
<div style="display:grid;grid-template-columns:1fr 24px 1fr 24px 1fr 24px 1fr;gap:0;align-items:start;margin-bottom:28px">

  <div class="tier-card tier-일반">
    <div class="tier-name">일반</div>
    <div class="tier-row">
      <span class="tier-row-key">승급 조건</span>
      <span class="tier-row-val" style="font-size:11px">가입 즉시 부여</span>
    </div>
    <div class="tier-row">
      <span class="tier-row-key">쿠폰 혜택</span>
      <span class="tier-row-val" style="font-size:11px">웰컴 쿠폰 1장</span>
    </div>
  </div>

  <div class="tier-arrow">›</div>

  <div class="tier-card tier-실버">
    <div class="tier-name">실버</div>
    <div class="tier-row">
      <span class="tier-row-key">월 방문</span>
      <span class="tier-row-val">5회 이상</span>
    </div>
    <div class="tier-row">
      <span class="tier-row-key">쿠폰 혜택</span>
      <span class="tier-row-val" style="font-size:11px">사이즈업 월 1장</span>
    </div>
  </div>

  <div class="tier-arrow">›</div>

  <div class="tier-card tier-골드">
    <div class="tier-name">골드</div>
    <div class="tier-row">
      <span class="tier-row-key">월 방문</span>
      <span class="tier-row-val">15회 이상</span>
    </div>
    <div class="tier-row">
      <span class="tier-row-key">쿠폰 혜택</span>
      <span class="tier-row-val" style="font-size:11px">아메리카노 월 1장</span>
    </div>
  </div>

  <div class="tier-arrow">›</div>

  <div class="tier-card tier-VIP">
    <div class="tier-name">VIP ✦</div>
    <div class="tier-row">
      <span class="tier-row-key">월 방문</span>
      <span class="tier-row-val">30회 이상</span>
    </div>
    <div class="tier-row">
      <span class="tier-row-key">쿠폰 혜택</span>
      <span class="tier-row-val" style="font-size:11px;color:#cc88ee">프리패스 월 2장</span>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════
     차트 행 1: 등급 도넛 + 방문 구간 막대
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">고객 분포</div>
<div style="display:grid;grid-template-columns:300px 1fr;gap:16px;margin-bottom:28px;align-items:stretch">

  <%-- 등급 도넛 --%>
  <div class="chart-panel">
    <div class="chart-title">등급별 고객 분포</div>
    <div class="donut-wrap">
      <div style="position:relative;width:170px;height:170px">
        <canvas id="gradeChart"></canvas>
      </div>
      <ul class="legend-list" id="grade-legend"></ul>
    </div>
  </div>

  <%-- 방문 구간 막대 --%>
  <div class="chart-panel" style="display:flex;flex-direction:column">
    <div class="chart-title">
      방문 횟수 구간별 고객 수
      <span class="chart-title-sub">등급 기준 구간과 동일</span>
    </div>
    <div style="position:relative;flex:1;min-height:180px">
      <canvas id="visitDistChart"></canvas>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════
     차트 행 2: 월별 신규 + Top 10 수평 막대
     ══════════════════════════════════════════════════════ --%>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:28px">

  <div class="chart-panel">
    <div class="chart-title">
      월별 신규 고객
      <span class="chart-title-sub">최근 6개월</span>
    </div>
    <div style="position:relative;height:210px">
      <canvas id="newCustomerChart"></canvas>
    </div>
  </div>

  <div class="chart-panel">
    <div class="chart-title">방문 횟수 Top 10</div>
    <div style="position:relative;height:210px">
      <canvas id="topCustomerChart"></canvas>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════
     Top 10 상세 테이블
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">상위 고객 상세</div>
<div class="glass-card" style="margin-bottom:28px">
  <div class="card-header" style="margin-bottom:16px">
    <h3>방문 횟수 Top 10 고객</h3>
    <span style="font-size:11px;color:var(--text-faint)">이름 클릭 시 상세 페이지로 이동</span>
  </div>
  <table class="crm-table">
    <thead>
      <tr>
        <th style="text-align:center;width:50px">순위</th>
        <th>고객명</th>
        <th>등급</th>
        <th style="text-align:right">방문 횟수</th>
        <th style="min-width:140px">방문 비율</th>
        <th>등록일</th>
        <th>메모</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty topCustomers}">
          <tr><td colspan="7" class="empty-msg">데이터가 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <%-- 최대 방문 횟수를 구해 width 비율 계산용 --%>
          <c:set var="maxVisit" value="0"/>
          <c:forEach var="t" items="${topCustomers}">
            <c:if test="${t.visitCount > maxVisit}"><c:set var="maxVisit" value="${t.visitCount}"/></c:if>
          </c:forEach>
          <%-- 동점자 처리용 변수 초기화 --%>
          <c:set var="prevVisitCount" value="-1"/>
          <c:set var="displayRank"    value="0"/>
          <c:forEach var="t" items="${topCustomers}" varStatus="st">
            <%-- 이전 행과 방문 횟수가 다를 때만 순위 증가 (동점이면 같은 순위 유지) --%>
            <c:if test="${t.visitCount != prevVisitCount}">
              <c:set var="displayRank" value="${st.index + 1}"/>
            </c:if>
            <c:set var="prevVisitCount" value="${t.visitCount}"/>
            <c:set var="rankClass" value="${displayRank == 1 ? 'rank-1' : displayRank == 2 ? 'rank-2' : displayRank == 3 ? 'rank-3' : ''}"/>
            <c:set var="barPct"    value="${maxVisit > 0 ? t.visitCount * 100 / maxVisit : 0}"/>
            <c:set var="barColor"  value="${'VIP' == t.grade ? 'rgba(180,100,220,0.75)' : '골드' == t.grade ? 'rgba(200,131,42,0.8)' : '실버' == t.grade ? 'rgba(192,192,192,0.6)' : 'rgba(255,255,255,0.25)'}"/>
            <tr>
              <td class="rank-no ${rankClass}">#${displayRank}</td>
              <td class="td-name">
                <a href="${pageContext.request.contextPath}/customer/detail?c_idx=${t.c_idx}">${t.name}</a>
              </td>
              <td><span class="grade-badge grade-${t.grade}">${t.grade}</span></td>
              <td style="text-align:right;font-weight:600">${t.visitCount}<span style="font-size:11px;color:var(--text-faint)">회</span></td>
              <td>
                <div class="progress-bar-wrap">
                  <div class="progress-bar-bg">
                    <div class="progress-bar-fill" style="width:${barPct}%;background:${barColor}"></div>
                  </div>
                  <span style="font-size:11px;color:var(--text-faint);width:36px;text-align:right">
                    <fmt:formatNumber value="${barPct}" maxFractionDigits="0"/>%
                  </span>
                </div>
              </td>
              <td class="td-faint" style="font-size:12px">${t.regDate}</td>
              <td class="td-muted" style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                <c:choose>
                  <c:when test="${not empty t.memo}">${t.memo}</c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<%-- ══════════════════════════════════════════════════════
     등급별 현황 테이블
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">등급 현황</div>
<div class="glass-card" style="margin-bottom:20px">
  <div class="card-header" style="margin-bottom:16px">
    <h3>등급별 고객 현황</h3>
    <span style="font-size:11px;color:var(--text-faint)">전체 ${totalCount}명 기준</span>
  </div>
  <table class="crm-table">
    <thead>
      <tr>
        <th>등급</th>
        <th>방문 기준</th>
        <th style="text-align:right">고객 수</th>
        <th style="min-width:200px">비율</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="row" items="${gradeDistribution}">
        <c:set var="pct"      value="${totalCount > 0 ? row.cnt * 100 / totalCount : 0}"/>
        <c:set var="criteria" value="${'VIP' == row.grade ? '월 방문 30회+' : '골드' == row.grade ? '월 방문 15회+' : '실버' == row.grade ? '월 방문 5회+' : '가입 즉시 부여'}"/>
        <c:set var="barColor" value="${'VIP' == row.grade ? 'rgba(180,100,220,0.75)' : '골드' == row.grade ? 'rgba(200,131,42,0.8)' : '실버' == row.grade ? 'rgba(192,192,192,0.6)' : 'rgba(255,255,255,0.25)'}"/>
        <tr>
          <td><span class="grade-badge grade-${row.grade}">${row.grade}</span></td>
          <td style="font-size:12px;color:var(--text-faint)">${criteria}</td>
          <td style="text-align:right;font-weight:600">${row.cnt}<span style="font-size:11px;color:var(--text-faint)">명</span></td>
          <td>
            <div class="progress-bar-wrap">
              <div class="progress-bar-bg" style="flex:1">
                <div class="progress-bar-fill" style="width:${pct}%;background:${barColor}"></div>
              </div>
              <span style="font-size:12px;color:var(--text-dim);width:40px;text-align:right">
                <fmt:formatNumber value="${pct}" maxFractionDigits="1"/>%
              </span>
            </div>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<%-- ══════════════════════════════════════════════════════
     이번 달 회원별 등급 진행 현황
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">이번 달 회원별 등급 현황</div>
<div class="glass-card" style="margin-bottom:28px">
  <div class="card-header" style="margin-bottom:16px">
    <h3>다음 등급까지 진행 현황</h3>
    <span style="font-size:11px;color:var(--text-faint)">이번 달 방문·결제 기준 / 이름 클릭 시 상세</span>
  </div>
  <table class="crm-table">
    <thead>
      <tr>
        <th>고객명</th>
        <th>현재 등급</th>
        <th>다음 등급</th>
        <th style="min-width:120px">이달 방문</th>
        <th style="min-width:160px">이달 결제액</th>
        <th style="min-width:100px">달성률</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty customerProgress}">
          <tr><td colspan="6" class="empty-msg">데이터가 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="cp" items="${customerProgress}">
            <%-- 다음 등급 및 목표 계산 --%>
            <c:choose>
              <c:when test="${cp.grade == 'VIP'}">
                <c:set var="nextGrade"    value="MAX"/>
                <c:set var="visitTarget"  value="0"/>
                <c:set var="amtTarget"    value="0"/>
              </c:when>
              <c:when test="${cp.grade == '골드'}">
                <c:set var="nextGrade"    value="VIP"/>
                <c:set var="visitTarget"  value="30"/>
                <c:set var="amtTarget"    value="0"/>
              </c:when>
              <c:when test="${cp.grade == '실버'}">
                <c:set var="nextGrade"    value="골드"/>
                <c:set var="visitTarget"  value="15"/>
                <c:set var="amtTarget"    value="70000"/>
              </c:when>
              <c:otherwise>
                <c:set var="nextGrade"    value="실버"/>
                <c:set var="visitTarget"  value="5"/>
                <c:set var="amtTarget"    value="30000"/>
              </c:otherwise>
            </c:choose>

            <%-- 방문 달성률 --%>
            <c:set var="visitPct" value="0"/>
            <c:if test="${visitTarget > 0}">
              <c:set var="visitPct" value="${cp.monthlyVisit * 100 / visitTarget}"/>
              <c:if test="${visitPct > 100}"><c:set var="visitPct" value="100"/></c:if>
            </c:if>

            <%-- 결제 달성률 --%>
            <c:set var="amtPct" value="0"/>
            <c:if test="${amtTarget > 0}">
              <c:set var="amtPct" value="${cp.monthlyAmount * 100 / amtTarget}"/>
              <c:if test="${amtPct > 100}"><c:set var="amtPct" value="100"/></c:if>
            </c:if>

            <%-- 종합 달성률 (방문 OR 결제 중 높은 것) --%>
            <c:set var="overallPct" value="${visitPct > amtPct ? visitPct : amtPct}"/>
            <c:if test="${cp.grade == 'VIP'}"><c:set var="overallPct" value="100"/></c:if>
            <c:if test="${nextGrade == 'VIP'}"><c:set var="overallPct" value="${visitPct}"/></c:if>

            <c:set var="barColor" value="${nextGrade == 'VIP' ? 'rgba(160,80,200,0.7)' : nextGrade == '골드' ? 'rgba(200,131,42,0.75)' : nextGrade == '실버' ? 'rgba(192,192,192,0.6)' : 'rgba(240,224,200,0.25)'}"/>

            <tr>
              <td class="td-name">
                <a href="${pageContext.request.contextPath}/customer/detail?c_idx=${cp.c_idx}">${cp.name}</a>
              </td>
              <td><span class="grade-badge grade-${cp.grade}">${cp.grade}</span></td>
              <td>
                <c:choose>
                  <c:when test="${cp.grade == 'VIP'}">
                    <span style="font-size:12px;color:var(--text-faint)">최고 등급</span>
                  </c:when>
                  <c:otherwise>
                    <span class="grade-badge grade-${nextGrade}">${nextGrade}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${visitTarget == 0}">
                    <span style="font-size:11px;color:var(--text-faint)">기준 없음</span>
                  </c:when>
                  <c:otherwise>
                    <div style="display:flex;align-items:center;gap:6px">
                      <div class="progress-bar-bg" style="width:70px">
                        <div class="progress-bar-fill" style="width:<fmt:formatNumber value="${visitPct}" maxFractionDigits="0"/>%;background:${barColor}"></div>
                      </div>
                      <span style="font-size:11px;color:var(--text-dim)">${cp.monthlyVisit}/${visitTarget}회</span>
                    </div>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${amtTarget == 0}">
                    <span style="font-size:11px;color:var(--text-faint)">—</span>
                  </c:when>
                  <c:otherwise>
                    <div style="display:flex;align-items:center;gap:6px">
                      <div class="progress-bar-bg" style="width:80px">
                        <div class="progress-bar-fill" style="width:<fmt:formatNumber value="${amtPct}" maxFractionDigits="0"/>%;background:${barColor}"></div>
                      </div>
                      <span style="font-size:11px;color:var(--text-dim)">
                        <fmt:formatNumber value="${cp.monthlyAmount}" pattern="#,###"/>원
                      </span>
                    </div>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${cp.grade == 'VIP'}">
                    <span style="font-size:12px;color:#cc88ee">✦ VIP</span>
                  </c:when>
                  <c:otherwise>
                    <div style="display:flex;align-items:center;gap:6px">
                      <div class="progress-bar-bg" style="width:60px">
                        <div class="progress-bar-fill" style="width:<fmt:formatNumber value="${overallPct}" maxFractionDigits="0"/>%;background:${barColor}"></div>
                      </div>
                      <span style="font-size:11px;color:var(--text-dim)">
                        <fmt:formatNumber value="${overallPct}" maxFractionDigits="0"/>%
                      </span>
                    </div>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<%-- ══════════════════════════════════════════════════════
     시간대별 / 요일별 방문 분석
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">피크 타임 분석</div>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:28px">
  <div class="chart-panel">
    <div class="chart-title">
      시간대별 방문 수
      <span class="chart-title-sub">최근 3개월 기준</span>
    </div>
    <div style="position:relative;height:220px">
      <canvas id="hourlyChart"></canvas>
    </div>
  </div>
  <div class="chart-panel">
    <div class="chart-title">
      요일별 방문 수
      <span class="chart-title-sub">최근 3개월 기준</span>
    </div>
    <div style="position:relative;height:220px">
      <canvas id="weekdayChart"></canvas>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════
     메뉴 ABC 분석 + 등급별 평균 결제액
     ══════════════════════════════════════════════════════ --%>
<div class="section-label">메뉴 및 등급별 분석</div>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:28px">

  <%-- 인기 메뉴 Top 10 --%>
  <div class="glass-card">
    <div class="card-header" style="margin-bottom:14px">
      <h3>메뉴 인기도 Top 10</h3>
      <span style="font-size:11px;color:var(--text-faint)">방문 기록 메뉴 기준</span>
    </div>
    <c:choose>
      <c:when test="${empty topMenuItems}">
        <div class="empty-msg" style="padding:20px 0">방문 기록에 메뉴 정보가 없습니다.</div>
      </c:when>
      <c:otherwise>
        <c:set var="maxMenuCnt" value="${topMenuItems[0].order_cnt}"/>
        <c:forEach var="m" items="${topMenuItems}" varStatus="ms">
          <c:set var="menuPct" value="${maxMenuCnt > 0 ? m.order_cnt * 100 / maxMenuCnt : 0}"/>
          <div style="margin-bottom:10px">
            <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:4px">
              <span style="color:var(--text)">
                <c:choose>
                  <c:when test="${ms.index == 0}">🥇</c:when>
                  <c:when test="${ms.index == 1}">🥈</c:when>
                  <c:when test="${ms.index == 2}">🥉</c:when>
                  <c:otherwise><span style="color:var(--text-faint);font-size:11px">#${ms.index+1}</span></c:otherwise>
                </c:choose>
                ${m.menu_item}
              </span>
              <span style="color:var(--text-dim);font-weight:600">${m.order_cnt}건</span>
            </div>
            <div class="prog-bar-bg" style="height:6px;background:rgba(255,255,255,0.07);border-radius:3px">
              <div style="height:100%;border-radius:3px;width:<fmt:formatNumber value="${menuPct}" maxFractionDigits="0"/>%;
                          background:linear-gradient(90deg,rgba(176,125,82,0.5),rgba(200,131,42,0.85))">
              </div>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- 등급별 평균 결제액 --%>
  <div class="glass-card">
    <div class="card-header" style="margin-bottom:14px">
      <h3>등급별 평균 결제액</h3>
      <span style="font-size:11px;color:var(--text-faint)">이번 달 결제액 기준</span>
    </div>
    <c:choose>
      <c:when test="${empty gradeAvgSpend}">
        <div class="empty-msg" style="padding:20px 0">데이터가 없습니다.</div>
      </c:when>
      <c:otherwise>
        <table class="crm-table">
          <thead>
            <tr>
              <th>등급</th>
              <th style="text-align:right">고객 수</th>
              <th style="text-align:right">평균 방문</th>
              <th style="text-align:right">평균 결제액</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="gs" items="${gradeAvgSpend}">
              <tr>
                <td><span class="grade-badge grade-${gs.grade}">${gs.grade}</span></td>
                <td style="text-align:right;color:var(--text-dim)">${gs.cnt}명</td>
                <td style="text-align:right;color:var(--text-dim)">${gs.avg_visit}회</td>
                <td style="text-align:right;font-weight:600">
                  <fmt:formatNumber value="${gs.avg_monthly}" pattern="#,###"/>원
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<%-- ── Chart.js ──────────────────────────────────────────── --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<script>
(function () {
  Chart.register(ChartDataLabels);
  Chart.defaults.color = 'rgba(232,213,187,0.65)';
  Chart.defaults.font.family = "'Noto Sans KR', sans-serif";

  const TOOLTIP = {
    backgroundColor: 'rgba(20,12,4,0.92)',
    titleColor: '#F0E0C8',
    bodyColor: 'rgba(240,224,200,0.75)',
    borderColor: 'rgba(240,224,200,0.13)',
    borderWidth: 1,
    padding: 11,
    cornerRadius: 7
  };
  const GRID  = 'rgba(240,224,200,0.06)';
  const GRIDX = 'rgba(0,0,0,0)';

  /* ── 1. 등급 도넛 ──────────────────────────────────────── */
  (function () {
    const gradeColors = {
      'VIP':  { bg: 'rgba(180,100,220,0.75)', border: 'rgba(180,100,220,0.9)' },
      '골드': { bg: 'rgba(200,131,42,0.80)',  border: 'rgba(200,131,42,0.9)'  },
      '실버': { bg: 'rgba(192,192,192,0.58)', border: 'rgba(192,192,192,0.7)' },
      '일반': { bg: 'rgba(240,224,200,0.18)', border: 'rgba(240,224,200,0.3)' }
    };
    const labels = [], counts = [], bgs = [], borders = [];

    <c:forEach var="row" items="${gradeDistribution}">
    labels .push('${row.grade}');
    counts .push(${row.cnt});
    (function(g){ var c=gradeColors[g]||gradeColors['일반']; bgs.push(c.bg); borders.push(c.border); })('${row.grade}');
    </c:forEach>

    new Chart(document.getElementById('gradeChart'), {
      type: 'doughnut',
      data: { labels, datasets: [{ data: counts, backgroundColor: bgs, borderColor: borders,
        borderWidth: 1.5, hoverOffset: 8 }] },
      options: {
        cutout: '62%',
        plugins: {
          legend: { display: false },
          tooltip: { ...TOOLTIP, callbacks: { label: ctx => ' ' + ctx.label + ': ' + ctx.raw + '명' } },
          datalabels: {
            color: '#fff',
            font: { size: 11, weight: '700' },
            formatter: function(val, ctx) {
              const total = ctx.dataset.data.reduce(function(a, b) { return a + b; }, 0);
              const pct = total > 0 ? Math.round(val / total * 100) : 0;
              return pct >= 8 ? pct + '%' : '';
            }
          }
        },
        animation: { animateRotate: true, duration: 900 }
      }
    });

    const legend = document.getElementById('grade-legend');
    const total  = counts.reduce((a, b) => a + b, 0);
    labels.forEach(function(lbl, i) {
      const pct = total > 0 ? Math.round(counts[i] / total * 100) : 0;
      const li  = document.createElement('li');
      li.className = 'legend-row';
      li.innerHTML =
        '<span class="legend-label"><span class="legend-dot" style="background:' + bgs[i] + '"></span>' + lbl + '</span>'
        + '<span class="legend-count">' + counts[i] + '명 <span style="opacity:.55">(' + pct + '%)</span></span>';
      legend.appendChild(li);
    });
  })();

  /* ── 2. 방문 구간 막대 ──────────────────────────────────── */
  (function () {
    const labels = [], counts = [];
    const tierColors = {
      '0회':    'rgba(240,224,200,0.22)',
      '1-4회':  'rgba(240,224,200,0.38)',
      '5-14회': 'rgba(192,192,192,0.60)',
      '15-29회':'rgba(200,131,42,0.75)',
      '30회+':  'rgba(180,100,220,0.78)'
    };
    const tierBorders = {
      '0회':    'rgba(240,224,200,0.70)',
      '1-4회':  'rgba(240,224,200,0.85)',
      '5-14회': 'rgba(192,192,192,0.90)',
      '15-29회':'rgba(220,160,55,1.0)',
      '30회+':  'rgba(210,140,255,1.0)'
    };

    <c:forEach var="row" items="${visitDistribution}">
    labels.push('${row.bucket}');
    counts.push(${row.cnt});
    </c:forEach>

    const bgColors     = labels.map(l => tierColors[l]  || 'rgba(240,224,200,0.3)');
    const borderColors = labels.map(l => tierBorders[l] || 'rgba(240,224,200,0.7)');

    new Chart(document.getElementById('visitDistChart'), {
      type: 'bar',
      data: { labels, datasets: [{ label: '고객 수', data: counts,
        backgroundColor: bgColors,
        borderColor: borderColors,
        borderWidth: 1.5, borderRadius: 7, borderSkipped: false }] },
      options: {
        responsive: true, maintainAspectRatio: false,
        layout: { padding: { top: 22, right: 4, bottom: 0, left: 0 } },
        plugins: {
          legend: { display: false },
          tooltip: { ...TOOLTIP, callbacks: { label: ctx => ' ' + ctx.raw + '명' } },
          datalabels: {
            anchor: 'end', align: 'top',
            color: 'rgba(240,224,200,0.85)',
            font: { size: 12, weight: '600' },
            formatter: function(val) { return val > 0 ? val + '명' : ''; }
          }
        },
        scales: {
          x: { grid: { color: GRIDX }, ticks: { font: { size: 12 } } },
          y: { grid: { color: GRID  }, beginAtZero: true,
               ticks: { font: { size: 11 }, stepSize: 1 } }
        },
        animation: { duration: 900 }
      }
    });
  })();

  /* ── 3. 월별 신규 꺾은선 ────────────────────────────────── */
  (function () {
    const labels = [], counts = [];

    <c:forEach var="row" items="${monthlyNewCustomers}">
    labels.push('${row.month}');
    counts.push(${row.cnt});
    </c:forEach>

    const ctx      = document.getElementById('newCustomerChart').getContext('2d');
    const areaGrad = ctx.createLinearGradient(0, 0, 0, 210);
    areaGrad.addColorStop(0, 'rgba(127,214,127,0.30)');
    areaGrad.addColorStop(1, 'rgba(127,214,127,0.01)');

    new Chart(ctx, {
      type: 'line',
      data: { labels, datasets: [{
        label: '신규 고객', data: counts,
        borderColor: 'rgba(127,214,127,0.85)',
        backgroundColor: areaGrad,
        pointBackgroundColor: 'rgba(127,214,127,1)',
        pointBorderColor: '#1e1410',
        pointBorderWidth: 2,
        pointRadius: 5, pointHoverRadius: 7,
        tension: 0.35, fill: true
      }] },
      options: {
        responsive: true, maintainAspectRatio: false,
        layout: { padding: { top: 22 } },
        plugins: {
          legend: { display: false },
          tooltip: { ...TOOLTIP, callbacks: { label: ctx => ' 신규 고객: ' + ctx.raw + '명' } },
          datalabels: {
            anchor: 'end', align: 'top', offset: 4,
            color: 'rgba(127,214,127,0.95)',
            font: { size: 11, weight: '700' },
            formatter: function(val) { return val + '명'; }
          }
        },
        scales: {
          x: { grid: { color: GRIDX }, ticks: { font: { size: 11 } } },
          y: { grid: { color: GRID  }, beginAtZero: true,
               ticks: { font: { size: 11 }, stepSize: 1 } }
        },
        animation: { duration: 900 }
      }
    });
  })();

  /* ── 4. Top 10 수평 막대 ────────────────────────────────── */
  (function () {
    const names = [], visits = [], grades = [];
    const gradeColorMap = {
      'VIP':  'rgba(180,100,220,0.78)',
      '골드': 'rgba(200,131,42,0.82)',
      '실버': 'rgba(192,192,192,0.62)',
      '일반': 'rgba(240,224,200,0.22)'
    };

    <c:forEach var="t" items="${topCustomers}">
    names .push('${t.name}');
    visits.push(${t.visitCount});
    grades.push('${t.grade}');
    </c:forEach>

    const bgColors = grades.map(g => gradeColorMap[g] || gradeColorMap['일반']);

    new Chart(document.getElementById('topCustomerChart'), {
      type: 'bar',
      data: { labels: names, datasets: [{
        label: '방문 횟수', data: visits,
        backgroundColor: bgColors,
        borderColor: bgColors.map(c => c.replace(/[\d.]+\)$/, '0.95)')),
        borderWidth: 1.5, borderRadius: 5, borderSkipped: false
      }] },
      options: {
        indexAxis: 'y',
        responsive: true, maintainAspectRatio: false,
        layout: { padding: { right: 36 } },
        plugins: {
          legend: { display: false },
          tooltip: {
            ...TOOLTIP,
            callbacks: {
              label: ctx => ' ' + ctx.raw + '회',
              title: items => items[0].label + ' (' + grades[items[0].dataIndex] + ')'
            }
          },
          datalabels: {
            anchor: 'end', align: 'right', offset: 4,
            color: 'rgba(240,224,200,0.85)',
            font: { size: 11, weight: '600' },
            formatter: function(val) { return val + '회'; }
          }
        },
        scales: {
          x: { grid: { color: GRID  }, beginAtZero: true, ticks: { font: { size: 11 } } },
          y: { grid: { display: false }, ticks: { font: { size: 12 } } }
        },
        animation: { duration: 900 }
      }
    });
  })();

  /* ── 5. 시간대별 방문 막대 ─────────────────────────────── */
  (function () {
    // 0~23시 전체 슬롯 초기화
    const hourLabels = [], hourCnts = [];
    const hourMap = {};
    <c:forEach var="h" items="${hourlyStats}">
    hourMap['${h.hour_slot}'] = ${h.visit_cnt};
    </c:forEach>
    for (let i = 0; i < 24; i++) {
      hourLabels.push(i + '시');
      hourCnts.push(hourMap[i] || 0);
    }
    new Chart(document.getElementById('hourlyChart').getContext('2d'), {
      type: 'bar',
      data: { labels: hourLabels, datasets: [{
        label: '방문', data: hourCnts,
        backgroundColor: hourCnts.map((v, i) => {
          const peak = Math.max(...hourCnts);
          const alpha = peak > 0 ? 0.25 + (v / peak) * 0.55 : 0.25;
          return `rgba(200,131,42,${alpha.toFixed(2)})`;
        }),
        borderRadius: 4
      }]},
      options: {
        responsive: true, maintainAspectRatio: false,
        layout: { padding: { top: 20 } },
        plugins: { legend: { display: false },
          tooltip: { ...TOOLTIP, callbacks: { label: c => ' 방문 ' + c.raw + '건' } },
          datalabels: {
            anchor: 'end', align: 'top',
            color: 'rgba(240,224,200,0.75)',
            font: { size: 9 },
            formatter: function(val) { return val > 0 ? val : ''; }
          }
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 10 }, maxRotation: 0 } },
          y: { grid: { color: GRID }, beginAtZero: true, ticks: { font: { size: 11 }, stepSize: 1 } }
        },
        animation: { duration: 900 }
      }
    });
  })();

  /* ── 6. 요일별 방문 막대 ─────────────────────────────────── */
  (function () {
    const DOW_LABELS = ['일', '월', '화', '수', '목', '금', '토'];
    const dowCnts = [0, 0, 0, 0, 0, 0, 0];
    <c:forEach var="w" items="${weekdayStats}">
    dowCnts[${w.dow} - 1] = ${w.visit_cnt};
    </c:forEach>
    new Chart(document.getElementById('weekdayChart').getContext('2d'), {
      type: 'bar',
      data: { labels: DOW_LABELS, datasets: [{
        label: '방문',
        data: dowCnts,
        backgroundColor: ['rgba(160,80,200,0.50)','rgba(80,140,220,0.55)','rgba(80,140,220,0.55)',
          'rgba(80,140,220,0.55)','rgba(80,140,220,0.55)','rgba(80,180,120,0.55)','rgba(160,80,200,0.50)'],
        borderRadius: 5
      }]},
      options: {
        responsive: true, maintainAspectRatio: false,
        layout: { padding: { top: 22 } },
        plugins: { legend: { display: false },
          tooltip: { ...TOOLTIP, callbacks: { label: c => ' 방문 ' + c.raw + '건' } },
          datalabels: {
            anchor: 'end', align: 'top',
            color: 'rgba(240,224,200,0.85)',
            font: { size: 12, weight: '600' },
            formatter: function(val) { return val > 0 ? val : ''; }
          }
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 13 } } },
          y: { grid: { color: GRID }, beginAtZero: true, ticks: { font: { size: 11 }, stepSize: 1 } }
        },
        animation: { duration: 900 }
      }
    });
  })();

})();
</script>

<%@ include file="footer.jsp" %>
