        </main>
    </div><!-- /main-wrap -->
</div><!-- /app -->

<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
<script>
    const d = new Date();
    document.getElementById("sidebar-date").textContent =
        d.getFullYear() + "년 " + (d.getMonth()+1) + "월 " + d.getDate() + "일";
</script>
</body>
</html>
