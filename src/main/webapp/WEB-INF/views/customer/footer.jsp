<%@ page pageEncoding="UTF-8" %>
        </main>
    </div><!-- /main-wrap -->
</div><!-- /app -->

<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
<script>
    const DAYS = ['일','월','화','수','목','금','토'];
    function updateClock() {
        const now = new Date();
        const h = String(now.getHours()).padStart(2,'0');
        const m = String(now.getMinutes()).padStart(2,'0');
        const s = String(now.getSeconds()).padStart(2,'0');
        document.getElementById("sidebar-time").textContent = h + ':' + m + ':' + s;
        document.getElementById("sidebar-date").textContent =
            now.getFullYear() + '년 ' + (now.getMonth()+1) + '월 ' + now.getDate() + '일 (' + DAYS[now.getDay()] + ')';
    }
    updateClock();
    setInterval(updateClock, 1000);

    // ── 전화번호 자동 하이픈 ──────────────────────────────
    document.querySelectorAll('input[name="phone"]').forEach(function(el) {
        el.addEventListener('input', function() {
            var v = this.value.replace(/\D/g, '');
            if (v.length <= 3) {
                this.value = v;
            } else if (v.length <= 7) {
                this.value = v.slice(0,3) + '-' + v.slice(3);
            } else {
                this.value = v.slice(0,3) + '-' + v.slice(3,7) + '-' + v.slice(7,11);
            }
        });
    });
</script>
</body>
</html>
