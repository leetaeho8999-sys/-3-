<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"  %>
<c:set var="pageTitle" value="메뉴 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu-full.css">

<div class="menu-page">

    <div class="menu-header">
        <p>Our Menu</p>
        <h1>Menu</h1>
        <div class="divider"></div>
    </div>

    <div class="category-tabs">
        <button class="tab-btn active" onclick="showTab('coffee', this)">커피</button>
        <button class="tab-btn" onclick="showTab('noncoffee', this)">논커피</button>
        <button class="tab-btn" onclick="showTab('ade', this)">에이드 &amp; 스무디</button>
        <button class="tab-btn" onclick="showTab('tea', this)">티</button>
        <button class="tab-btn" onclick="showTab('frappe', this)">블렌디드 / 프라페</button>
        <button class="tab-btn" onclick="showTab('dessert', this)">디저트 &amp; 푸드</button>
    </div>

    <!-- ===== 커피 (COFFEE, ESPRESSO, LATTE) ===== -->
    <div id="coffee" class="menu-section active">
        <h2 class="section-title">Coffee</h2>
        <p class="section-sub">커피</p>
        <div class="menu-grid">
            <c:forEach var="m" items="${menuList}">
            <c:if test="${m.category == 'COFFEE' || m.category == 'ESPRESSO' || m.category == 'LATTE'}">
            <c:set var="tempType" value="HOT / ICE"/>
            <%-- 외부 URL(http/https)은 그대로, 로컬 경로는 contextPath 붙임 --%>
            <c:set var="imgSrc" value="${m.imageUrl}"/>
            <c:if test="${not empty m.imageUrl and not fn:startsWith(m.imageUrl, 'http://') and not fn:startsWith(m.imageUrl, 'https://')}">
              <c:set var="imgSrc" value="${pageContext.request.contextPath}${m.imageUrl}"/>
            </c:if>
            <div class="menu-card" onclick="openDetail(this)"
                 data-name="<c:out value='${m.name}'/>"
                 data-type="${tempType}"
                 data-price="${m.price}"
                 data-ice-extra="${m.icePrice}"
                 data-size-grande="${m.sizeUpchargeGrande}"
                 data-size-venti="${m.sizeUpchargeVenti}"
                 data-has-size="${m.category != 'ESPRESSO' and m.category != 'DESSERT'}"
                 data-img="${imgSrc}"
                 data-story="<c:out value='${m.story}'/>">
                <c:choose>
                    <c:when test="${not empty imgSrc}">
                        <img src="${imgSrc}" alt="<c:out value='${m.name}'/>" onerror="imgError(this)">
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">📷 사진 준비 중</div>
                    </c:otherwise>
                </c:choose>
                <p class="item-name"><c:out value="${m.name}"/></p>
                <p class="item-type">${tempType}</p>
                <div class="price-row">
                    <span class="price"><fmt:formatNumber value="${m.price}" pattern="#,##0"/>원</span>
                </div>
            </div>
            </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- ===== 논커피 (NONCOFFEE) ===== -->
    <div id="noncoffee" class="menu-section">
        <h2 class="section-title">Non-Coffee</h2>
        <p class="section-sub">논커피</p>
        <div class="menu-grid">
            <c:forEach var="m" items="${menuList}">
            <c:if test="${m.category == 'NONCOFFEE'}">
            <c:set var="tempType" value="HOT / ICE"/>
            <c:set var="imgSrc" value="${m.imageUrl}"/>
            <c:if test="${not empty m.imageUrl and not fn:startsWith(m.imageUrl, 'http://') and not fn:startsWith(m.imageUrl, 'https://')}">
              <c:set var="imgSrc" value="${pageContext.request.contextPath}${m.imageUrl}"/>
            </c:if>
            <div class="menu-card" onclick="openDetail(this)"
                 data-name="<c:out value='${m.name}'/>"
                 data-type="${tempType}"
                 data-price="${m.price}"
                 data-ice-extra="${m.icePrice}"
                 data-size-grande="${m.sizeUpchargeGrande}"
                 data-size-venti="${m.sizeUpchargeVenti}"
                 data-has-size="${m.category != 'ESPRESSO' and m.category != 'DESSERT'}"
                 data-img="${imgSrc}"
                 data-story="<c:out value='${m.story}'/>">
                <c:choose>
                    <c:when test="${not empty imgSrc}">
                        <img src="${imgSrc}" alt="<c:out value='${m.name}'/>" onerror="imgError(this)">
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">📷 사진 준비 중</div>
                    </c:otherwise>
                </c:choose>
                <p class="item-name"><c:out value="${m.name}"/></p>
                <p class="item-type">${tempType}</p>
                <div class="price-row">
                    <span class="price"><fmt:formatNumber value="${m.price}" pattern="#,##0"/>원</span>
                </div>
            </div>
            </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- ===== 에이드 & 스무디 (ADE, SMOOTHIE) ===== -->
    <div id="ade" class="menu-section">
        <h2 class="section-title">Ade &amp; Smoothie</h2>
        <p class="section-sub">에이드 &amp; 스무디</p>
        <div class="menu-grid">
            <c:forEach var="m" items="${menuList}">
            <c:if test="${m.category == 'ADE' || m.category == 'SMOOTHIE'}">
            <c:set var="tempType" value="ICE"/>
            <c:set var="imgSrc" value="${m.imageUrl}"/>
            <c:if test="${not empty m.imageUrl and not fn:startsWith(m.imageUrl, 'http://') and not fn:startsWith(m.imageUrl, 'https://')}">
              <c:set var="imgSrc" value="${pageContext.request.contextPath}${m.imageUrl}"/>
            </c:if>
            <div class="menu-card" onclick="openDetail(this)"
                 data-name="<c:out value='${m.name}'/>"
                 data-type="${tempType}"
                 data-price="${m.price}"
                 data-ice-extra="${m.icePrice}"
                 data-size-grande="${m.sizeUpchargeGrande}"
                 data-size-venti="${m.sizeUpchargeVenti}"
                 data-has-size="${m.category != 'ESPRESSO' and m.category != 'DESSERT'}"
                 data-img="${imgSrc}"
                 data-story="<c:out value='${m.story}'/>">
                <c:choose>
                    <c:when test="${not empty imgSrc}">
                        <img src="${imgSrc}" alt="<c:out value='${m.name}'/>" onerror="imgError(this)">
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">📷 사진 준비 중</div>
                    </c:otherwise>
                </c:choose>
                <p class="item-name"><c:out value="${m.name}"/></p>
                <p class="item-type">${tempType}</p>
                <div class="price-row">
                    <span class="price"><fmt:formatNumber value="${m.price}" pattern="#,##0"/>원</span>
                </div>
            </div>
            </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- ===== 티 (TEA) ===== -->
    <div id="tea" class="menu-section">
        <h2 class="section-title">Tea</h2>
        <p class="section-sub">티</p>
        <div class="menu-grid">
            <c:forEach var="m" items="${menuList}">
            <c:if test="${m.category == 'TEA'}">
            <c:set var="tempType" value="HOT / ICE"/>
            <c:set var="imgSrc" value="${m.imageUrl}"/>
            <c:if test="${not empty m.imageUrl and not fn:startsWith(m.imageUrl, 'http://') and not fn:startsWith(m.imageUrl, 'https://')}">
              <c:set var="imgSrc" value="${pageContext.request.contextPath}${m.imageUrl}"/>
            </c:if>
            <div class="menu-card" onclick="openDetail(this)"
                 data-name="<c:out value='${m.name}'/>"
                 data-type="${tempType}"
                 data-price="${m.price}"
                 data-ice-extra="${m.icePrice}"
                 data-size-grande="${m.sizeUpchargeGrande}"
                 data-size-venti="${m.sizeUpchargeVenti}"
                 data-has-size="${m.category != 'ESPRESSO' and m.category != 'DESSERT'}"
                 data-img="${imgSrc}"
                 data-story="<c:out value='${m.story}'/>">
                <c:choose>
                    <c:when test="${not empty imgSrc}">
                        <img src="${imgSrc}" alt="<c:out value='${m.name}'/>" onerror="imgError(this)">
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">📷 사진 준비 중</div>
                    </c:otherwise>
                </c:choose>
                <p class="item-name"><c:out value="${m.name}"/></p>
                <p class="item-type">${tempType}</p>
                <div class="price-row">
                    <span class="price"><fmt:formatNumber value="${m.price}" pattern="#,##0"/>원</span>
                </div>
            </div>
            </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- ===== 블렌디드 / 프라페 (FRAPPE) ===== -->
    <div id="frappe" class="menu-section">
        <h2 class="section-title">Blended &amp; Frappe</h2>
        <p class="section-sub">블렌디드 / 프라페</p>
        <div class="menu-grid">
            <c:forEach var="m" items="${menuList}">
            <c:if test="${m.category == 'FRAPPE'}">
            <c:set var="tempType" value="ICE"/>
            <c:set var="imgSrc" value="${m.imageUrl}"/>
            <c:if test="${not empty m.imageUrl and not fn:startsWith(m.imageUrl, 'http://') and not fn:startsWith(m.imageUrl, 'https://')}">
              <c:set var="imgSrc" value="${pageContext.request.contextPath}${m.imageUrl}"/>
            </c:if>
            <div class="menu-card" onclick="openDetail(this)"
                 data-name="<c:out value='${m.name}'/>"
                 data-type="${tempType}"
                 data-price="${m.price}"
                 data-ice-extra="${m.icePrice}"
                 data-size-grande="${m.sizeUpchargeGrande}"
                 data-size-venti="${m.sizeUpchargeVenti}"
                 data-has-size="${m.category != 'ESPRESSO' and m.category != 'DESSERT'}"
                 data-img="${imgSrc}"
                 data-story="<c:out value='${m.story}'/>">
                <c:choose>
                    <c:when test="${not empty imgSrc}">
                        <img src="${imgSrc}" alt="<c:out value='${m.name}'/>" onerror="imgError(this)">
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">📷 사진 준비 중</div>
                    </c:otherwise>
                </c:choose>
                <p class="item-name"><c:out value="${m.name}"/></p>
                <p class="item-type">${tempType}</p>
                <div class="price-row">
                    <span class="price"><fmt:formatNumber value="${m.price}" pattern="#,##0"/>원</span>
                </div>
            </div>
            </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- ===== 디저트 & 푸드 (DESSERT, SPECIAL) ===== -->
    <div id="dessert" class="menu-section">
        <h2 class="section-title">Dessert &amp; Food</h2>
        <p class="section-sub">디저트 &amp; 푸드</p>
        <div class="menu-grid">
            <c:forEach var="m" items="${menuList}">
            <c:if test="${m.category == 'DESSERT' || m.category == 'SPECIAL'}">
            <c:choose>
                <c:when test="${m.category == 'DESSERT'}"><c:set var="tempType" value="Dessert"/></c:when>
                <c:otherwise><c:set var="tempType" value="HOT / ICE"/></c:otherwise>
            </c:choose>
            <c:set var="imgSrc" value="${m.imageUrl}"/>
            <c:if test="${not empty m.imageUrl and not fn:startsWith(m.imageUrl, 'http://') and not fn:startsWith(m.imageUrl, 'https://')}">
              <c:set var="imgSrc" value="${pageContext.request.contextPath}${m.imageUrl}"/>
            </c:if>
            <div class="menu-card" onclick="openDetail(this)"
                 data-name="<c:out value='${m.name}'/>"
                 data-type="${tempType}"
                 data-price="${m.price}"
                 data-ice-extra="${m.icePrice}"
                 data-size-grande="${m.sizeUpchargeGrande}"
                 data-size-venti="${m.sizeUpchargeVenti}"
                 data-has-size="${m.category != 'ESPRESSO' and m.category != 'DESSERT'}"
                 data-img="${imgSrc}"
                 data-story="<c:out value='${m.story}'/>">
                <c:choose>
                    <c:when test="${not empty imgSrc}">
                        <img src="${imgSrc}" alt="<c:out value='${m.name}'/>" onerror="imgError(this)">
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">📷 사진 준비 중</div>
                    </c:otherwise>
                </c:choose>
                <p class="item-name"><c:out value="${m.name}"/></p>
                <p class="item-type">${tempType}</p>
                <div class="price-row">
                    <span class="price"><fmt:formatNumber value="${m.price}" pattern="#,##0"/>원</span>
                </div>
            </div>
            </c:if>
            </c:forEach>
        </div>
    </div>

</div>

<!-- 상세 모달 -->
<div id="detail-modal" class="modal-overlay">
    <div class="modal-box">
        <button class="modal-close" onclick="closeDetail()">&#x2715;</button>
        <img id="modal-img" class="modal-img" src="" alt="">
        <div id="modal-img-placeholder" class="modal-img-placeholder" style="display:none">
            <span>📷</span>
            <span>사진 준비 중</span>
        </div>
        <div class="modal-body">
            <p id="modal-tag" class="modal-tag"></p>
            <h2 id="modal-name" class="modal-name"></h2>
            <p id="modal-story" class="modal-story"></p>
            <div class="modal-footer">
                <span id="modal-price" class="modal-price"></span>
                <button id="btn-buy" class="btn-buy" onclick="onBuyClick(this)">구매하기</button>
            </div>
        </div>
    </div>
</div>

<!-- 주문 옵션 모달 -->
<div id="order-modal" class="order-modal-overlay">
    <div class="order-modal-box">
        <button class="order-modal-close" onclick="closeOrderModal()">&#x2715;</button>
        <h3 id="order-modal-item-name" class="order-modal-name"></h3>

        <div id="order-temp-row">
            <span class="order-opt-label">온도</span>
            <div id="order-temp-group" class="order-temp-group">
                <button class="order-temp-btn active" data-temp="HOT" onclick="selectTemp('HOT')">HOT</button>
                <button class="order-temp-btn"        data-temp="ICE" onclick="selectTemp('ICE')">ICE</button>
            </div>
        </div>

        <div id="order-size-row">
            <span class="order-opt-label">사이즈</span>
            <div id="order-size-group" class="order-temp-group">
                <button class="order-temp-btn active" data-size="TALL"   onclick="selectSize('TALL')">TALL</button>
                <button class="order-temp-btn"        data-size="GRANDE" onclick="selectSize('GRANDE')">GRANDE</button>
                <button class="order-temp-btn"        data-size="VENTI"  onclick="selectSize('VENTI')">VENTI</button>
            </div>
        </div>

        <span class="order-opt-label">수량</span>
        <div class="order-qty-group">
            <button class="order-qty-btn" onclick="changeQty(-1)">−</button>
            <span id="order-qty-val" class="order-qty-val">1</span>
            <button class="order-qty-btn" onclick="changeQty(1)">+</button>
        </div>

        <c:if test="${not empty sessionScope.m_id}">
            <div class="order-points-row">
                <div class="order-points-label">
                    사용 가능 포인트: <strong id="order-points-balance">0</strong>P
                </div>
                <div class="order-points-input-wrap">
                    <input type="number" id="order-points-input"
                           class="order-points-input"
                           min="0" step="100" placeholder="0" />
                    <button type="button" id="order-points-all-btn"
                            class="order-points-all-btn">전액 사용</button>
                </div>
                <small class="order-points-hint">1,000P부터 100P 단위로 사용 가능</small>
                <div id="order-points-preview" class="order-points-preview" style="display:none;">
                    포인트 사용 시 실 결제액: <strong id="order-points-pay-amount">0원</strong>
                </div>
            </div>
        </c:if>

        <div class="order-total-row">
            <span class="order-total-label">합계</span>
            <span id="order-total-price" class="order-total-price">0원</span>
        </div>

        <div class="order-btn-row">
            <button id="order-cart-btn" class="order-cart-btn"
                    data-original-text="장바구니 담기"
                    onclick="addToCartFromModal()">장바구니 담기</button>
            <button id="order-pay-btn" class="order-pay-btn"
                    data-original-text="바로 결제"
                    onclick="startPayment('${tossClientKey}')">바로 결제</button>
        </div>
    </div>
</div>

<script src="https://js.tosspayments.com/v1/payment"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css?v=20260427c">
<script>
  window.contextPath      = '${pageContext.request.contextPath}';
  window.customerName     = '${sessionScope.m_name}';
  window.userPointBalance = ${userPointBalance != null ? userPointBalance : 0};
</script>
<script src="${pageContext.request.contextPath}/js/menu.js?v=20260424"></script>
<script src="${pageContext.request.contextPath}/js/detail.js?v=20260424"></script>
<script src="${pageContext.request.contextPath}/js/order.js?v=20260427"></script>

<%@ include file="../common/footer.jsp" %>
