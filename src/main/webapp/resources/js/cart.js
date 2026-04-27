/* =====================================================
   cart.js — 사이드 슬라이드 장바구니 패널 + 결제 이관
   (window.ctxPath / window.customerName / window.tossClientKey 는 cart-panel.jsp 에서 주입)
   ===================================================== */

function _ctx() { return window.ctxPath || ''; }

/** 숫자 → "1,234원" */
function _won(n) { return (n || 0).toLocaleString('ko-KR') + '원'; }

/** HTML escape */
function _esc(s) {
    return String(s || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

/** 헤더 🛒 뱃지 갱신 */
function refreshBadge() {
    fetch(_ctx() + '/cart/count')
        .then(function(res) { return res.ok ? res.json() : { count: 0 }; })
        .then(function(data) {
            var badge = document.getElementById('cart-badge');
            if (!badge) return;
            var n = data.count || 0;
            badge.textContent = n;
            badge.style.display = n > 0 ? '' : 'none';
        })
        .catch(function() {});
}

/** 사이드 패널 열기 */
function openCart() {
    fetch(_ctx() + '/cart/list')
        .then(function(res) {
            if (res.status === 401) {
                location.href = _ctx() + '/member/login?redirect=' +
                    encodeURIComponent(location.pathname + location.search);
                return null;
            }
            return res.ok ? res.json() : null;
        })
        .then(function(data) {
            if (!data) return;
            renderCartItems(data.items || [], data.totalAmount || 0);
            document.getElementById('cart-count-inline').textContent = (data.items || []).length;
            document.getElementById('cart-overlay').classList.add('open');
            document.getElementById('cart-panel').classList.add('open');
            document.body.style.overflow = 'hidden';
        })
        .catch(function() { showAlert('장바구니를 불러올 수 없습니다.', '오류', 'error'); });
}

function closeCart() {
    document.getElementById('cart-overlay').classList.remove('open');
    document.getElementById('cart-panel').classList.remove('open');
    document.body.style.overflow = '';
}

/** 아이템 리스트 렌더 */
function renderCartItems(items, total) {
    var ul = document.getElementById('cart-items');
    var empty = document.getElementById('cart-empty');
    var checkoutBtn = document.getElementById('cart-checkout-btn');
    ul.innerHTML = '';

    if (!items || items.length === 0) {
        empty.style.display = '';
        checkoutBtn.disabled = true;
        document.getElementById('cart-total').textContent = '0원';
        return;
    }
    empty.style.display = 'none';
    checkoutBtn.disabled = false;

    items.forEach(function(item) {
        var li = document.createElement('li');
        li.className = 'cart-item';
        var tempBadge = (item.temperature && item.temperature !== 'NONE')
            ? '<span class="cart-item__meta-tag">' + _esc(item.temperature) + '</span>' : '';
        var sizeBadge = (item.size && item.size !== 'NONE')
            ? '<span class="cart-item__meta-tag">' + _esc(item.size) + '</span>' : '';
        li.innerHTML =
            '<div class="cart-item__top">' +
                '<span class="cart-item__name">' + _esc(item.menuName) + '</span>' +
                '<button type="button" class="cart-item__remove" onclick="removeCartItem(' + item.cartIdx + ')">삭제</button>' +
            '</div>' +
            '<div class="cart-item__meta">' + tempBadge + sizeBadge +
                '<span style="margin-left:6px">₩' + _won(item.unitPrice).replace('원','') + ' / 잔</span>' +
            '</div>' +
            '<div class="cart-item__bottom">' +
                '<div class="cart-qty-group">' +
                    '<button type="button" class="cart-qty-btn" onclick="changeCartQty(' + item.cartIdx + ', ' + (item.quantity - 1) + ')">−</button>' +
                    '<span class="cart-qty-val">' + item.quantity + '</span>' +
                    '<button type="button" class="cart-qty-btn" onclick="changeCartQty(' + item.cartIdx + ', ' + (item.quantity + 1) + ')">+</button>' +
                '</div>' +
                '<span class="cart-item__subtotal">' + _won(item.subtotal) + '</span>' +
            '</div>';
        ul.appendChild(li);
    });
    document.getElementById('cart-total').textContent = _won(total);
    _cartTotalCache = total;
    _refreshPointsPreview();
}

/** 수량 변경 (0 이면 서버에서 삭제 처리) */
function changeCartQty(cartIdx, newQty) {
    if (newQty < 0) return;
    if (newQty > 99) { showToast('최대 99개까지 가능합니다.', 'info'); return; }
    var form = new URLSearchParams();
    form.append('cartIdx', cartIdx);
    form.append('quantity', newQty);
    fetch(_ctx() + '/cart/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: form
    })
    .then(function(res) { return res.ok ? res.json() : null; })
    .then(function() {
        _reloadCartPanelData();
        refreshBadge();
    });
}

/** 개별 삭제 */
function removeCartItem(cartIdx) {
    var form = new URLSearchParams();
    form.append('cartIdx', cartIdx);
    fetch(_ctx() + '/cart/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: form
    })
    .then(function(res) { return res.ok ? res.json() : null; })
    .then(function() {
        _reloadCartPanelData();
        refreshBadge();
    });
}

/** 전체 비우기 (확인 포함) */
async function clearCartConfirm() {
    var ok = await showConfirm('장바구니를 전체 비우시겠습니까?', '전체 비우기 확인',
                               { dangerMode: true, confirmText: '비우기' });
    if (!ok) return;
    fetch(_ctx() + '/cart/clear', { method: 'POST' })
        .then(function(res) { return res.ok ? res.json() : null; })
        .then(function() {
            _reloadCartPanelData();
            refreshBadge();
        });
}

/** 패널 열려있을 때 재조회 */
function _reloadCartPanelData() {
    fetch(_ctx() + '/cart/list')
        .then(function(res) { return res.ok ? res.json() : null; })
        .then(function(data) {
            if (!data) return;
            renderCartItems(data.items || [], data.totalAmount || 0);
            document.getElementById('cart-count-inline').textContent = (data.items || []).length;
        });
}

/** 현재 cart 합계 (마지막 렌더 결과 캐시) — 포인트 미리보기·검증용 */
var _cartTotalCache = 0;

/** 입력란에서 사용 포인트 읽기 (정수, 0 이상). 빈 값/NaN 은 0. */
function _readPointsInput() {
    var el = document.getElementById('cart-points-input');
    if (!el) return 0;
    var v = parseInt(el.value, 10);
    return (isNaN(v) || v < 0) ? 0 : v;
}

/** 합계 행 옆에 "포인트 사용 시 X원" 미리보기 갱신 */
function _refreshPointsPreview() {
    var box   = document.getElementById('cart-points-preview');
    var label = document.getElementById('cart-points-payable');
    if (!box || !label) return;
    var useP = _readPointsInput();
    if (useP <= 0) {
        box.style.display = 'none';
        return;
    }
    var pay = Math.max(0, _cartTotalCache - useP);
    label.textContent = pay.toLocaleString('ko-KR') + '원';
    box.style.display = '';
}

/** "전액 사용" 버튼 — min(잔액, 합계) 를 100P 단위 내림으로 입력 */
function useAllPoints() {
    var bal = parseInt(window.userPointBalance || 0, 10);
    var max = Math.min(bal, _cartTotalCache);
    var floored = Math.floor(max / 100) * 100;
    if (floored < 1000) floored = 0;   // 1,000P 미만이면 사용 불가
    var el = document.getElementById('cart-points-input');
    if (el) el.value = floored;
    _refreshPointsPreview();
}

/** 포인트 사용 입력값 검증 — 통과하면 정수 반환, 실패하면 null + 토스트 */
function _validatePointsInput(useP, total) {
    var bal = parseInt(window.userPointBalance || 0, 10);
    if (useP < 0)         { showToast('포인트는 0 이상이어야 합니다.', 'info'); return null; }
    if (useP === 0)       return 0;
    if (useP % 100 !== 0) { showToast('포인트는 100P 단위로 사용해야 합니다.', 'info'); return null; }
    if (useP < 1000)      { showToast('포인트는 1,000P 이상부터 사용 가능합니다.', 'info'); return null; }
    if (useP > bal)       { showToast('포인트 잔액이 부족합니다.', 'info'); return null; }
    if (useP > total)     { showToast('사용 포인트가 결제 금액을 초과할 수 없습니다.', 'info'); return null; }
    return useP;
}

/** 장바구니 전체 결제 → /cart/checkout (pointsToUse 포함) → Toss 결제창 */
function checkoutCart() {
    var btn = document.getElementById('cart-checkout-btn');
    if (btn.disabled) return;

    // 클라이언트 사전 검증 (서버에서도 다시 검증)
    var rawUseP = _readPointsInput();
    var useP    = _validatePointsInput(rawUseP, _cartTotalCache);
    if (useP === null) return;

    btn.disabled = true;
    btn.textContent = '처리 중...';

    var form = new URLSearchParams();
    form.append('pointsToUse', useP);

    fetch(_ctx() + '/cart/checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: form
    })
        .then(function(res) {
            if (res.status === 401) {
                location.href = _ctx() + '/member/login?redirect=' +
                    encodeURIComponent(location.pathname + location.search);
                return null;
            }
            return res.json().then(function(data) { return { status: res.status, data: data }; });
        })
        .then(function(result) {
            if (!result) return;
            if (result.status !== 200 || result.data.error) {
                showAlert(result.data.error || '결제 준비 중 오류가 발생했습니다.', '오류', 'error');
                btn.disabled = false;
                btn.textContent = '주문하기';
                return;
            }
            var base = window.location.origin + _ctx();
            var toss = TossPayments(window.tossClientKey);
            toss.requestPayment('카드', {
                amount:       result.data.amount,
                orderId:      result.data.orderId,
                orderName:    '장바구니 주문',
                customerName: window.customerName || '',
                successUrl:   base + '/order/success',
                failUrl:      base + '/order/fail'
            }).catch(function(err) {
                if (err.code !== 'USER_CANCEL') {
                    showAlert('결제 오류: ' + err.message, '결제 실패', 'error');
                }
                btn.disabled = false;
                btn.textContent = '주문하기';
            });
        })
        .catch(function() {
            showAlert('네트워크 오류가 발생했습니다.', '오류', 'error');
            btn.disabled = false;
            btn.textContent = '주문하기';
        });
}

// 페이지 로드 시 뱃지 갱신 + 포인트 입력 리스너 등록
document.addEventListener('DOMContentLoaded', function() {
    refreshBadge();
    var pInput = document.getElementById('cart-points-input');
    if (pInput) pInput.addEventListener('input', _refreshPointsPreview);
});
// ESC 로 패널 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        var panel = document.getElementById('cart-panel');
        if (panel && panel.classList.contains('open')) closeCart();
    }
});
