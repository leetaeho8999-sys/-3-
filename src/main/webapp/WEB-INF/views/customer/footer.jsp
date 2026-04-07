        </main>
    </div><!-- /main-wrap -->
</div><!-- /app -->

<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
<script>
    const d = new Date();
    document.getElementById("sidebar-date").textContent =
        d.getFullYear() + "년 " + (d.getMonth()+1) + "월 " + d.getDate() + "일";

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
