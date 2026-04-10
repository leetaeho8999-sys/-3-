<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"   prefix="fmt" %>
<c:set var="pageTitle" value="대시보드"/>
<c:set var="activeMenu" value="dashboard"/>
<%@ include file="header.jsp" %>

<div class="stat-grid">
  <div class="stat-card">
    <div class="stat-label">전체 고객</div>
    <div class="stat-value">
      ${totalCount}
      <span style="font-size:14px;color:var(--text-faint)">명</span>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-label">👑 VIP</div>
    <div class="stat-value" style="color:#cc88ff">
      ${vipCount}
      <span style="font-size:14px;color:var(--text-faint)">명</span>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-label">⭐ 골드</div>
    <div class="stat-value">
      ${goldCount}
      <span style="font-size:14px;color:var(--text-faint)">명</span>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-label">🥈 실버</div>
    <div class="stat-value" style="color:#d8d8d8">
      ${silverCount}
      <span style="font-size:14px;color:var(--text-faint)">명</span>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-label">이번 달 신규</div>
    <div class="stat-value">
      ${newCount}
      <span style="font-size:14px;color:var(--text-faint)">명</span>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-label">이번 달 방문</div>
    <div class="stat-value">
      ${totalMonthlyVisit}
      <span style="font-size:14px;color:var(--text-faint)">회</span>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-label">이번 달 매출</div>
    <div class="stat-value">
      <fmt:formatNumber value="${totalMonthlyAmount}" pattern="#,###"/>
      <span style="font-size:14px;color:var(--text-faint)">원</span>
    </div>
  </div>
</div>

<div class="glass-card">
  <div class="card-header">
    <h3>최근 등록 고객</h3>
    <a href="${pageContext.request.contextPath}/customer/list" class="card-link">전체 보기 →</a>
  </div>
  <table class="crm-table">
    <thead>
      <tr><th>이름</th><th>연락처</th><th>등급</th><th>방문횟수</th><th>등록일</th></tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty recentList}">
          <tr><td colspan="5" class="empty-msg">등록된 고객이 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="c" items="${recentList}">
            <tr>
              <td class="td-name">${c.name}</td>
              <td class="td-muted">${c.phone}</td>
              <td><span class="grade-badge grade-${c.grade}">${c.grade}</span></td>
              <td class="td-muted">${c.visitCount}회</td>
              <td class="td-faint">${c.regDate}</td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<%-- ══════════════════════════════════════════════════════
     스케줄러 캘린더
     ══════════════════════════════════════════════════════ --%>
<style>
  .cal-nav-btn {
    background: var(--bg-hover);
    border: 1px solid var(--border);
    color: var(--text);
    width: 32px; height: 32px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 18px;
    line-height: 1;
    display: flex; align-items: center; justify-content: center;
    transition: var(--transition);
  }
  .cal-nav-btn:hover { background: var(--border-hi); border-color: var(--brown-hi); }

  .cal-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 6px;
  }
  .cal-day-header {
    text-align: center;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.08em;
    color: var(--text-faint);
    padding: 6px 0 10px;
  }
  .cal-cell {
    min-height: 90px;
    background: rgba(255,255,255,0.03);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 8px 7px 6px;
    cursor: pointer;
    transition: background 0.15s, border-color 0.15s;
    position: relative;
    overflow: hidden;
  }
  .cal-cell:hover { background: var(--bg-hover); border-color: var(--border-hi); }
  .cal-cell.today {
    border-color: var(--brown-hi);
    background: rgba(176,125,82,0.08);
  }
  .cal-cell.today .cal-day-num { color: var(--brown-hi); font-weight: 700; }
  .cal-cell.other-month { opacity: 0.35; }
  .cal-cell.sun .cal-day-num { color: rgba(255,120,120,0.85); }
  .cal-cell.sat .cal-day-num { color: rgba(130,170,240,0.85); }

  .cal-day-num {
    font-size: 13px;
    font-weight: 600;
    color: var(--text-dim);
    margin-bottom: 5px;
    display: block;
  }
  .cal-task-item {
    font-size: 10.5px;
    padding: 2px 6px;
    border-radius: 4px;
    margin-bottom: 3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.5;
  }
  .cal-task-more {
    font-size: 10px;
    color: var(--text-faint);
    padding: 1px 4px;
  }

  /* 모달 */
  #cal-modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.55);
    z-index: 1000;
    align-items: center;
    justify-content: center;
  }
  #cal-modal-overlay.open { display: flex; }
  #cal-modal {
    background: var(--bg-card);
    border: 1px solid var(--border-hi);
    border-radius: 14px;
    padding: 28px 28px 22px;
    min-width: 340px;
    max-width: 420px;
    width: 100%;
    box-shadow: 0 20px 60px rgba(0,0,0,0.6);
  }
  #modal-date-title {
    font-family: 'Noto Serif KR', serif;
    font-size: 16px;
    color: var(--text);
    margin-bottom: 18px;
    padding-bottom: 12px;
    border-bottom: 1px solid var(--border);
  }
  #modal-task-list { margin-bottom: 16px; min-height: 20px; }
  .modal-task-row {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 6px 0;
    border-bottom: 1px solid rgba(255,255,255,0.05);
  }
  .modal-task-row:last-child { border-bottom: none; }
  .modal-task-dot {
    width: 8px; height: 8px;
    border-radius: 50%;
    flex-shrink: 0;
  }
  .modal-task-text {
    flex: 1;
    font-size: 13px;
    color: var(--text-dim);
  }
  .modal-task-del {
    background: none;
    border: none;
    color: var(--text-faint);
    cursor: pointer;
    font-size: 15px;
    padding: 0 4px;
    line-height: 1;
    transition: color 0.15s;
  }
  .modal-task-del:hover { color: rgba(255,100,100,0.8); }

  .modal-input-row {
    display: flex;
    gap: 8px;
    margin-bottom: 10px;
  }
  #modal-task-input {
    flex: 1;
    background: rgba(255,255,255,0.05);
    border: 1px solid var(--border);
    border-radius: 7px;
    padding: 8px 12px;
    color: var(--text);
    font-size: 13px;
    outline: none;
    transition: border-color 0.15s;
  }
  #modal-task-input:focus { border-color: var(--brown-hi); }
  #modal-task-input::placeholder { color: var(--text-faint); }

  .modal-color-row {
    display: flex;
    gap: 8px;
    margin-bottom: 16px;
  }
  .color-dot-btn {
    width: 22px; height: 22px;
    border-radius: 50%;
    border: 2px solid transparent;
    cursor: pointer;
    transition: transform 0.15s;
  }
  .color-dot-btn:hover { transform: scale(1.2); }
  .color-dot-btn.selected { border-color: #fff; }

  .modal-btn-row {
    display: flex;
    gap: 8px;
    justify-content: flex-end;
  }
  .modal-btn {
    padding: 7px 18px;
    border-radius: 7px;
    border: 1px solid var(--border);
    font-size: 13px;
    cursor: pointer;
    transition: var(--transition);
  }
  .modal-btn-add {
    background: rgba(176,125,82,0.25);
    border-color: var(--brown-hi);
    color: var(--brown-hi);
  }
  .modal-btn-add:hover { background: rgba(176,125,82,0.4); }
  .modal-btn-close {
    background: transparent;
    color: var(--text-faint);
  }
  .modal-btn-close:hover { background: var(--bg-hover); color: var(--text-dim); }
</style>

<div class="glass-card" style="margin-top:24px">
  <div class="card-header" style="margin-bottom:20px">
    <div style="display:flex;align-items:center;gap:14px">
      <button class="cal-nav-btn" onclick="calChangeMonth(-1)">‹</button>
      <h3 id="cal-title" style="min-width:150px;text-align:center;font-size:16px"></h3>
      <button class="cal-nav-btn" onclick="calChangeMonth(1)">›</button>
    </div>
    <span style="font-size:11px;color:var(--text-faint)">날짜 클릭 → 일정 추가 / 수정</span>
  </div>

  <div class="cal-grid" style="margin-bottom:6px">
    <div class="cal-day-header" style="color:rgba(255,120,120,0.8)">일</div>
    <div class="cal-day-header">월</div>
    <div class="cal-day-header">화</div>
    <div class="cal-day-header">수</div>
    <div class="cal-day-header">목</div>
    <div class="cal-day-header">금</div>
    <div class="cal-day-header" style="color:rgba(130,170,240,0.8)">토</div>
  </div>
  <div id="cal-body" class="cal-grid"></div>
</div>

<%-- 일정 입력 모달 --%>
<div id="cal-modal-overlay" onclick="calCloseModal()">
  <div id="cal-modal" onclick="event.stopPropagation()">
    <div id="modal-date-title"></div>
    <div id="modal-task-list"></div>
    <div class="modal-input-row">
      <input id="modal-task-input" type="text" placeholder="할 일을 입력하세요..." maxlength="50"
             onkeydown="if(event.key==='Enter') calAddTask()">
    </div>
    <div class="modal-color-row" id="modal-color-row"></div>
    <div class="modal-btn-row">
      <button class="modal-btn modal-btn-close" onclick="calCloseModal()">닫기</button>
      <button class="modal-btn modal-btn-add" onclick="calAddTask()">+ 추가</button>
    </div>
  </div>
</div>

<script>
(function () {
  const STORE_KEY = 'brewcrm_schedule';
  const COLORS = [
    { key: 'cream',  bg: 'rgba(240,224,200,0.18)', dot: 'rgba(240,224,200,0.7)',  label: '기본'   },
    { key: 'gold',   bg: 'rgba(200,131,42,0.22)',  dot: 'rgba(200,160,60,0.9)',   label: '마케팅' },
    { key: 'green',  bg: 'rgba(100,200,120,0.18)', dot: 'rgba(100,200,120,0.85)', label: '이벤트' },
    { key: 'purple', bg: 'rgba(160,80,220,0.20)',  dot: 'rgba(180,110,240,0.85)', label: 'VIP'    },
    { key: 'blue',   bg: 'rgba(100,160,240,0.18)', dot: 'rgba(120,180,255,0.85)', label: '회의'   },
    { key: 'red',    bg: 'rgba(220,80,80,0.18)',   dot: 'rgba(240,100,100,0.85)', label: '긴급'   }
  ];

  /* ── 카페 업주 고정 반복 일정 ── */
  // monthly: 매월 특정 일 고정
  // weekly : 매주 특정 요일 고정 (0=일,1=월,...,6=토)
  // quarter: 1,4,7,10월에만 추가로 발생하는 월별 일정
  const RECURRING = {
    monthly: [
      { day: 1,  text: '월간 운영 계획 수립',      color: 'blue'   },
      { day: 5,  text: '4대보험 납부 마감',         color: 'red'    },
      { day: 10, text: '전월 매출 정산·보고',       color: 'gold'   },
      { day: 15, text: '직원 급여 지급',            color: 'purple' },
      { day: 20, text: '다음달 식재료 발주 계획',   color: 'green'  },
      { day: 'last', text: '월말 재고 실사',        color: 'green'  }
    ],
    quarterly: [                          // 1·4·7·10월 25일
      { day: 25, months: [0,3,6,9], text: '부가세 신고·납부', color: 'red' }
    ],
    weekly: [
      { dow: 1, text: '주간 식재료 발주',     color: 'green' },
      { dow: 3, text: '매장 위생·청소 점검',  color: 'cream' },
      { dow: 5, text: '주간 매출 집계',       color: 'gold'  }
    ]
  };

  /* 해당 날짜의 고정 이벤트 목록 반환 */
  function getRecurring(year, month, day) {
    const result = [];
    const lastDay = new Date(year, month + 1, 0).getDate();
    const dow = new Date(year, month, day).getDay();

    RECURRING.monthly.forEach(function(r) {
      const target = r.day === 'last' ? lastDay : r.day;
      if (day === target) result.push({ text: r.text, color: r.color, fixed: true });
    });
    RECURRING.quarterly.forEach(function(r) {
      if (r.months.indexOf(month) !== -1 && day === r.day)
        result.push({ text: r.text, color: r.color, fixed: true });
    });
    RECURRING.weekly.forEach(function(r) {
      if (dow === r.dow) result.push({ text: r.text, color: r.color, fixed: true });
    });
    return result;
  }

  let curYear, curMonth, selDate, selYear, selMonth, selDay, selColor = 'cream';
  const today = new Date();

  function loadData() {
    try { return JSON.parse(localStorage.getItem(STORE_KEY)) || {}; }
    catch(e) { return {}; }
  }
  function saveData(d) { localStorage.setItem(STORE_KEY, JSON.stringify(d)); }
  function dateKey(y, m, d) {
    return y + '-' + String(m+1).padStart(2,'0') + '-' + String(d).padStart(2,'0');
  }

  /* ── 캘린더 렌더 ── */
  function renderCalendar() {
    const data = loadData();
    document.getElementById('cal-title').textContent = curYear + '년 ' + (curMonth + 1) + '월';

    const body   = document.getElementById('cal-body');
    body.innerHTML = '';

    const first    = new Date(curYear, curMonth, 1).getDay();
    const daysCur  = new Date(curYear, curMonth + 1, 0).getDate();
    const daysPrev = new Date(curYear, curMonth, 0).getDate();
    const todayKey = dateKey(today.getFullYear(), today.getMonth(), today.getDate());
    let cells = [];

    for (let i = first - 1; i >= 0; i--)
      cells.push({ day: daysPrev - i, month: curMonth - 1, year: curYear, other: true });
    for (let d = 1; d <= daysCur; d++)
      cells.push({ day: d, month: curMonth, year: curYear, other: false });
    const remain = 42 - cells.length;
    for (let d = 1; d <= remain; d++)
      cells.push({ day: d, month: curMonth + 1, year: curYear, other: true });

    cells.forEach(function(c) {
      const key      = dateKey(c.year, c.month, c.day);
      const userTasks= data[key] || [];
      const fixedTasks = c.other ? [] : getRecurring(c.year, c.month, c.day);
      const allTasks = fixedTasks.concat(userTasks);
      const dow      = new Date(c.year, c.month, c.day).getDay();

      const cell = document.createElement('div');
      cell.className = 'cal-cell'
        + (c.other   ? ' other-month' : '')
        + (key === todayKey ? ' today' : '')
        + (dow === 0 ? ' sun' : dow === 6 ? ' sat' : '');
      cell.onclick = function () { calOpenModal(key, c.year, c.month, c.day); };

      const num = document.createElement('span');
      num.className = 'cal-day-num';
      num.textContent = c.day;
      cell.appendChild(num);

      allTasks.slice(0, 3).forEach(function(t) {
        const col  = COLORS.find(function(x){ return x.key === t.color; }) || COLORS[0];
        const item = document.createElement('div');
        item.className = 'cal-task-item';
        item.style.cssText = 'background:' + col.bg + ';color:' + col.dot
          + (t.fixed ? ';opacity:0.75;font-style:italic' : '');
        item.textContent = (t.fixed ? '* ' : '') + t.text;
        cell.appendChild(item);
      });
      if (allTasks.length > 3) {
        const more = document.createElement('div');
        more.className = 'cal-task-more';
        more.textContent = '+' + (allTasks.length - 3) + '개 더보기';
        cell.appendChild(more);
      }
      body.appendChild(cell);
    });
  }

  /* ── 모달 ── */
  function calOpenModal(key, y, m, d) {
    selDate = key; selYear = y; selMonth = m; selDay = d;
    const months = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
    document.getElementById('modal-date-title').textContent = y + '년 ' + months[m] + ' ' + d + '일';
    renderModalTasks();

    const cr = document.getElementById('modal-color-row');
    cr.innerHTML = '';
    COLORS.forEach(function(c) {
      const btn = document.createElement('button');
      btn.className = 'color-dot-btn' + (c.key === selColor ? ' selected' : '');
      btn.style.background = c.dot;
      btn.title = c.label;
      btn.onclick = function() {
        selColor = c.key;
        cr.querySelectorAll('.color-dot-btn').forEach(function(b){ b.classList.remove('selected'); });
        btn.classList.add('selected');
      };
      cr.appendChild(btn);
    });

    document.getElementById('modal-task-input').value = '';
    document.getElementById('cal-modal-overlay').classList.add('open');
    setTimeout(function(){ document.getElementById('modal-task-input').focus(); }, 80);
  }

  function renderModalTasks() {
    const data       = loadData();
    const userTasks  = data[selDate] || [];
    const fixedTasks = getRecurring(selYear, selMonth, selDay);
    const list       = document.getElementById('modal-task-list');
    list.innerHTML   = '';

    // 고정 일정 섹션
    if (fixedTasks.length > 0) {
      const hdr = document.createElement('div');
      hdr.style.cssText = 'font-size:10px;color:var(--text-faint);letter-spacing:0.1em;margin-bottom:6px;margin-top:2px';
      hdr.textContent = '* 고정 일정';
      list.appendChild(hdr);
      fixedTasks.forEach(function(t) {
        const col = COLORS.find(function(x){ return x.key === t.color; }) || COLORS[0];
        const row = document.createElement('div');
        row.className = 'modal-task-row';
        row.style.opacity = '0.7';
        row.innerHTML =
          '<div class="modal-task-dot" style="background:' + col.dot + '"></div>' +
          '<span class="modal-task-text" style="font-style:italic">' + escHtml(t.text) + '</span>' +
          '<span style="font-size:10px;color:var(--text-faint);padding:0 4px">고정</span>';
        list.appendChild(row);
      });
    }

    // 사용자 일정 섹션
    if (userTasks.length > 0) {
      const hdr = document.createElement('div');
      hdr.style.cssText = 'font-size:10px;color:var(--text-faint);letter-spacing:0.1em;margin-bottom:6px;margin-top:' + (fixedTasks.length > 0 ? '12px' : '2px');
      hdr.textContent = '내 일정';
      list.appendChild(hdr);
      userTasks.forEach(function(t, idx) {
        const col = COLORS.find(function(x){ return x.key === t.color; }) || COLORS[0];
        const row = document.createElement('div');
        row.className = 'modal-task-row';
        row.innerHTML =
          '<div class="modal-task-dot" style="background:' + col.dot + '"></div>' +
          '<span class="modal-task-text">' + escHtml(t.text) + '</span>' +
          '<button class="modal-task-del" title="삭제" onclick="calDeleteTask(' + idx + ')">✕</button>';
        list.appendChild(row);
      });
    }

    if (fixedTasks.length === 0 && userTasks.length === 0) {
      list.innerHTML = '<div style="font-size:12px;color:var(--text-faint);padding:4px 0 10px">등록된 일정이 없습니다.</div>';
    }
  }

  window.calAddTask = function() {
    const input = document.getElementById('modal-task-input');
    const text  = input.value.trim();
    if (!text) { input.focus(); return; }
    const data  = loadData();
    if (!data[selDate]) data[selDate] = [];
    data[selDate].push({ text: text, color: selColor });
    saveData(data);
    input.value = '';
    renderModalTasks();
    renderCalendar();
  };

  window.calDeleteTask = function(idx) {
    const data = loadData();
    if (data[selDate]) {
      data[selDate].splice(idx, 1);
      if (data[selDate].length === 0) delete data[selDate];
    }
    saveData(data);
    renderModalTasks();
    renderCalendar();
  };

  window.calCloseModal = function() {
    document.getElementById('cal-modal-overlay').classList.remove('open');
  };

  window.calChangeMonth = function(delta) {
    curMonth += delta;
    if (curMonth > 11) { curMonth = 0;  curYear++; }
    if (curMonth < 0)  { curMonth = 11; curYear--; }
    renderCalendar();
  };

  function escHtml(s) {
    return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  }

  curYear  = today.getFullYear();
  curMonth = today.getMonth();
  renderCalendar();
})();
</script>

<%@ include file="footer.jsp" %>
