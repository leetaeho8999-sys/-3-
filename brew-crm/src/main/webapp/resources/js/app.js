// BREW CRM — app.js
// Spring MVC 서버가 비즈니스 로직을 모두 담당하므로
// 여기서는 UI 보조 기능만 처리합니다.

// 사이드바 날짜 표시
const d = new Date();
const dateEl = document.getElementById("sidebar-date");
if (dateEl) {
    dateEl.textContent =
        d.getFullYear() + "년 " + (d.getMonth() + 1) + "월 " + d.getDate() + "일";
}

// 테이블 행 클릭 시 상세 이동 (선택적 UX 향상)
document.querySelectorAll(".crm-table tbody tr").forEach(row => {
    row.style.cursor = "pointer";
});
