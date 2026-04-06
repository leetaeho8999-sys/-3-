<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>
<c:set var="pageTitle"  value="매출 통계"/>
<c:set var="activeMenu" value="stats"/>
<%@ include file="header.jsp" %>

<%-- ── 요약 카드 ────────────────────────────────────────────── --%>
<div class="stat-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:24px">

  <div class="stat-card">
    <div class="stat-label">이번 달 매출</div>
    <div class="stat-value" style="font-size:22px">
      <fmt:formatNumber value="${thisMonthRevenue}" pattern="#,###"/>원
    </div>
    <c:if test="${lastMonthRevenue > 0}">
      <c:set var="diff" value="${thisMonthRevenue - lastMonthRevenue}"/>
      <div style="font-size:12px;margin-top:6px;
                  color:${diff >= 0 ? '#7fd67f' : '#ff8888'}">
        전월 대비 <fmt:formatNumber value="${diff}" pattern="+#,###;-#,###"/>원
      </div>
    </c:if>
  </div>

  <div class="stat-card">
    <div class="stat-label">지난 달 매출</div>
    <div class="stat-value" style="font-size:22px">
      <fmt:formatNumber value="${lastMonthRevenue}" pattern="#,###"/>원
    </div>
  </div>

  <div class="stat-card">
    <div class="stat-label">이번 달 거래</div>
    <div class="stat-value">${thisMonthCount}건</div>
  </div>

  <div class="stat-card">
    <div class="stat-label">평균 객단가</div>
    <div class="stat-value" style="font-size:22px">
      <fmt:formatNumber value="${avgAmount}" pattern="#,###"/>원
    </div>
  </div>
</div>

<%-- ── 상단 차트 행: 월별 매출 막대 + 등급별 도넛 ──────────── --%>
<div style="display:grid;grid-template-columns:1fr 320px;gap:20px;margin-bottom:20px;align-items:start">

  <%-- 월별 매출 추이 (Bar) --%>
  <div class="glass-card" style="padding:24px">
    <div class="card-header" style="margin-bottom:16px">
      <h3>월별 매출 추이 <span style="font-size:12px;color:var(--white-dim);font-weight:400">(최근 6개월)</span></h3>
    </div>
    <div style="position:relative;height:240px">
      <canvas id="monthlyRevenueChart"></canvas>
    </div>
  </div>

  <%-- 등급별 매출 도넛 --%>
  <div class="glass-card" style="padding:24px">
    <div class="card-header" style="margin-bottom:16px">
      <h3>등급별 매출 비중</h3>
    </div>
    <div style="position:relative;width:190px;height:190px;margin:0 auto 16px">
      <canvas id="gradeRevenueChart"></canvas>
    </div>
    <ul id="grade-legend" style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:7px"></ul>
  </div>
</div>

<%-- ── 하단 차트 행: 신규 고객 + Top 5 고객 ───────────────────── --%>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px">

  <%-- 월별 신규 고객 수 (Line) --%>
  <div class="glass-card" style="padding:24px">
    <div class="card-header" style="margin-bottom:16px">
      <h3>월별 신규 고객 <span style="font-size:12px;color:var(--white-dim);font-weight:400">(최근 6개월)</span></h3>
    </div>
    <div style="position:relative;height:200px">
      <canvas id="newCustomerChart"></canvas>
    </div>
  </div>

  <%-- Top 5 고객 수평 막대 (HorizontalBar) --%>
  <div class="glass-card" style="padding:24px">
    <div class="card-header" style="margin-bottom:16px">
      <h3>매출 Top 5 고객</h3>
    </div>
    <div style="position:relative;height:200px">
      <canvas id="topCustomerChart"></canvas>
    </div>
  </div>
</div>

<%-- ── 스프레드시트형 월별 상세 테이블 ─────────────────────── --%>
<div class="glass-card" style="padding:24px;margin-bottom:20px">
  <div class="card-header" style="margin-bottom:16px">
    <h3>월별 매출 상세</h3>
  </div>
  <table class="crm-table">
    <thead>
      <tr>
        <th>월</th>
        <th style="text-align:right">매출 합계</th>
        <th style="text-align:right">거래 건수</th>
        <th style="text-align:right">평균 객단가</th>
        <th>비교</th>
      </tr>
    </thead>
    <tbody>
      <c:set var="prevAmt" value="0"/>
      <c:forEach var="row" items="${monthlyRevenue}" varStatus="st">
        <c:set var="amt" value="${row.totalAmount}"/>
        <c:set var="cnt" value="${row.cnt}"/>
        <c:set var="avg" value="${cnt > 0 ? amt / cnt : 0}"/>
        <tr>
          <td style="font-weight:500">${row.month}</td>
          <td style="text-align:right;color:var(--amber-light)">
            <fmt:formatNumber value="${amt}" pattern="#,###"/>원
          </td>
          <td style="text-align:right;color:var(--white-dim)">${cnt}건</td>
          <td style="text-align:right;color:var(--white-dim)">
            <fmt:formatNumber value="${avg}" pattern="#,###"/>원
          </td>
          <td>
            <c:choose>
              <c:when test="${st.first || prevAmt == 0}">
                <span style="color:var(--white-dim);font-size:12px">—</span>
              </c:when>
              <c:when test="${amt >= prevAmt}">
                <span style="color:#7fd67f;font-size:12px">
                  ▲ <fmt:formatNumber value="${amt - prevAmt}" pattern="#,###"/>원
                </span>
              </c:when>
              <c:otherwise>
                <span style="color:#ff8888;font-size:12px">
                  ▼ <fmt:formatNumber value="${prevAmt - amt}" pattern="#,###"/>원
                </span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
        <c:set var="prevAmt" value="${amt}"/>
      </c:forEach>
    </tbody>
  </table>
</div>

<%-- ── Top 5 고객 상세 테이블 ────────────────────────────────── --%>
<div class="glass-card" style="padding:24px;margin-bottom:20px">
  <div class="card-header" style="margin-bottom:16px">
    <h3>매출 기여 Top 5 고객</h3>
  </div>
  <table class="crm-table">
    <thead>
      <tr>
        <th>순위</th>
        <th>고객명</th>
        <th>등급</th>
        <th style="text-align:right">총 매출</th>
        <th style="text-align:right">방문 횟수</th>
        <th style="text-align:right">평균 객단가</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="t" items="${topCustomers}" varStatus="st">
        <c:set var="tavg" value="${t.cnt > 0 ? t.totalAmount / t.cnt : 0}"/>
        <tr>
          <td style="font-weight:600;color:var(--amber-light)">#${st.index + 1}</td>
          <td class="td-name">${t.customerName}</td>
          <td><span class="grade-badge grade-${t.grade}">${t.grade}</span></td>
          <td style="text-align:right;color:var(--amber-light)">
            <fmt:formatNumber value="${t.totalAmount}" pattern="#,###"/>원
          </td>
          <td style="text-align:right;color:var(--white-dim)">${t.cnt}건</td>
          <td style="text-align:right;color:var(--white-dim)">
            <fmt:formatNumber value="${tavg}" pattern="#,###"/>원
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<%-- ── Chart.js 스크립트 ─────────────────────────────────────── --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function () {
  /* ── 공통 Chart.js 기본값 ──────────────────────────────── */
  Chart.defaults.color = 'rgba(245,237,214,0.70)';
  Chart.defaults.font.family = "'DM Sans', sans-serif";

  const TOOLTIP_OPTS = {
    backgroundColor: 'rgba(18,10,3,0.88)',
    titleColor: '#F5EDD6',
    bodyColor: 'rgba(255,255,255,0.75)',
    borderColor: 'rgba(255,255,255,0.15)',
    borderWidth: 1,
    padding: 10
  };
  const GRID_COLOR = 'rgba(255,255,255,0.07)';

  /* ── 1. 월별 매출 막대 차트 ────────────────────────────── */
  (function () {
    const labels  = [];
    const amounts = [];
    const counts  = [];

    <c:forEach var="row" items="${monthlyRevenue}">
    labels .push('${row.month}');
    amounts.push(${row.totalAmount});
    counts .push(${row.cnt});
    </c:forEach>

    const ctx = document.getElementById('monthlyRevenueChart').getContext('2d');

    /* 그라데이션 바 색상 */
    const grad = ctx.createLinearGradient(0, 0, 0, 240);
    grad.addColorStop(0,   'rgba(200,131,42,0.85)');
    grad.addColorStop(1,   'rgba(200,131,42,0.20)');

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels,
        datasets: [{
          label: '매출 (원)',
          data: amounts,
          backgroundColor: grad,
          borderColor: 'rgba(200,131,42,0.9)',
          borderWidth: 1.5,
          borderRadius: 6,
          borderSkipped: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            ...TOOLTIP_OPTS,
            callbacks: {
              label: ctx => ' 매출: ' + ctx.raw.toLocaleString() + '원',
              afterLabel: (ctx) => {
                const c = counts[ctx.dataIndex];
                const avg = c > 0 ? Math.round(ctx.raw / c) : 0;
                return [' 건수: ' + c + '건', ' 객단가: ' + avg.toLocaleString() + '원'];
              }
            }
          }
        },
        scales: {
          x: { grid: { color: GRID_COLOR }, ticks: { font: { size: 11 } } },
          y: {
            grid: { color: GRID_COLOR },
            ticks: {
              font: { size: 11 },
              callback: v => v.toLocaleString() + '원'
            }
          }
        },
        animation: { duration: 900 }
      }
    });
  })();

  /* ── 2. 등급별 매출 도넛 차트 ──────────────────────────── */
  (function () {
    const gradeColors = {
      'VIP':  { bg: 'rgba(180,100,220,0.75)', border: 'rgba(180,100,220,0.9)' },
      '골드': { bg: 'rgba(200,131,42,0.80)',  border: 'rgba(200,131,42,0.9)'  },
      '실버': { bg: 'rgba(192,192,192,0.60)', border: 'rgba(192,192,192,0.7)' },
      '일반': { bg: 'rgba(255,255,255,0.18)', border: 'rgba(255,255,255,0.3)' }
    };

    const labels  = [];
    const amounts = [];
    const bgs     = [];
    const borders = [];

    <c:forEach var="row" items="${gradeRevenue}">
    labels .push('${row.grade}');
    amounts.push(${row.totalAmount});
    (function (g) {
      var c = gradeColors[g] || gradeColors['일반'];
      bgs    .push(c.bg);
      borders.push(c.border);
    })('${row.grade}');
    </c:forEach>

    const ctx = document.getElementById('gradeRevenueChart').getContext('2d');
    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels,
        datasets: [{ data: amounts, backgroundColor: bgs, borderColor: borders, borderWidth: 1.5, hoverOffset: 6 }]
      },
      options: {
        cutout: '65%',
        plugins: {
          legend: { display: false },
          tooltip: {
            ...TOOLTIP_OPTS,
            callbacks: {
              label: ctx => ' ' + ctx.label + ': ' + ctx.raw.toLocaleString() + '원'
            }
          }
        },
        animation: { animateRotate: true, duration: 800 }
      }
    });

    /* 범례 수동 렌더링 */
    const legend = document.getElementById('grade-legend');
    const total  = amounts.reduce((a, b) => a + b, 0);
    labels.forEach(function (lbl, i) {
      const pct = total > 0 ? Math.round(amounts[i] / total * 100) : 0;
      const li  = document.createElement('li');
      li.style.cssText = 'display:flex;justify-content:space-between;align-items:center;font-size:13px';
      li.innerHTML =
        '<span><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:'
        + bgs[i] + ';margin-right:8px"></span>' + lbl + '</span>'
        + '<span style="color:var(--white-dim)">'
        + amounts[i].toLocaleString() + '원 (' + pct + '%)</span>';
      legend.appendChild(li);
    });
  })();

  /* ── 3. 월별 신규 고객 꺾은선 차트 ────────────────────── */
  (function () {
    const labels = [];
    const counts = [];

    <c:forEach var="row" items="${monthlyNewCustomers}">
    labels.push('${row.month}');
    counts.push(${row.cnt});
    </c:forEach>

    const ctx = document.getElementById('newCustomerChart').getContext('2d');
    const areaGrad = ctx.createLinearGradient(0, 0, 0, 200);
    areaGrad.addColorStop(0,   'rgba(127,214,127,0.35)');
    areaGrad.addColorStop(1,   'rgba(127,214,127,0.02)');

    new Chart(ctx, {
      type: 'line',
      data: {
        labels,
        datasets: [{
          label: '신규 고객 수',
          data: counts,
          borderColor: 'rgba(127,214,127,0.85)',
          backgroundColor: areaGrad,
          pointBackgroundColor: 'rgba(127,214,127,1)',
          pointBorderColor:     '#fff',
          pointRadius: 5,
          pointHoverRadius: 7,
          tension: 0.35,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { ...TOOLTIP_OPTS, callbacks: { label: ctx => ' 신규 고객: ' + ctx.raw + '명' } }
        },
        scales: {
          x: { grid: { color: GRID_COLOR }, ticks: { font: { size: 11 } } },
          y: {
            grid: { color: GRID_COLOR },
            beginAtZero: true,
            ticks: { font: { size: 11 }, stepSize: 1 }
          }
        },
        animation: { duration: 900 }
      }
    });
  })();

  /* ── 4. Top 5 고객 수평 막대 차트 ─────────────────────── */
  (function () {
    const names   = [];
    const amounts = [];
    const grades  = [];
    const gradeColorMap = {
      'VIP':  'rgba(180,100,220,0.80)',
      '골드': 'rgba(200,131,42,0.85)',
      '실버': 'rgba(192,192,192,0.65)',
      '일반': 'rgba(255,255,255,0.25)'
    };

    <c:forEach var="t" items="${topCustomers}">
    names  .push('${t.customerName}');
    amounts.push(${t.totalAmount});
    grades .push('${t.grade}');
    </c:forEach>

    const bgColors = grades.map(g => gradeColorMap[g] || gradeColorMap['일반']);

    const ctx = document.getElementById('topCustomerChart').getContext('2d');
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: names,
        datasets: [{
          label: '총 매출 (원)',
          data: amounts,
          backgroundColor: bgColors,
          borderColor: bgColors.map(c => c.replace(/[\d.]+\)$/, '0.95)')),
          borderWidth: 1.5,
          borderRadius: 5,
          borderSkipped: false
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            ...TOOLTIP_OPTS,
            callbacks: {
              label: ctx => ' ' + ctx.raw.toLocaleString() + '원',
              title: (items) => items[0].label + ' (' + grades[items[0].dataIndex] + ')'
            }
          }
        },
        scales: {
          x: {
            grid: { color: GRID_COLOR },
            ticks: { font: { size: 11 }, callback: v => v.toLocaleString() }
          },
          y: { grid: { display: false }, ticks: { font: { size: 12 } } }
        },
        animation: { duration: 900 }
      }
    });
  })();

})();
</script>

<%@ include file="footer.jsp" %>
