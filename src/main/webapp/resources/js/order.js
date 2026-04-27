/* =====================================================
   order.js — 주문 옵션 모달 + TossPayments 결제 연동
   ===================================================== */

var _orderState = {
  name:      '',
  unitPrice: 0,
  iceExtra:  0,   // ICE 선택 시 추가금 (menu_t.ice_extra_price)
  quantity:  1,
  temp:      'NONE',   // HOT / ICE / NONE
  hasTempOption: false,
  // 사이즈 (스타벅스 기준: TALL=0 / GRANDE +500 / VENTI +1000)
  size:             'NONE', // TALL / GRANDE / VENTI / NONE
  sizeGrandeExtra:  0,
  sizeVentiExtra:   0,
  hasSizeOption:    false
};

/** 메뉴 카드의 "구매하기" → 주문 옵션 모달 열기 */
function openOrderModal(name, priceStr, type, iceExtra, hasSize, grandeExtra, ventiExtra) {
  var price     = parseInt((priceStr || '0').replace(/[^0-9]/g, ''), 10);
  var typeUpper = (type || '').toUpperCase();

  _orderState.name      = name;
  _orderState.unitPrice = price;
  _orderState.iceExtra  = iceExtra || 0;
  _orderState.quantity  = 1;

  // HOT/ICE 옵션 여부 판단
  var hasHot = typeUpper.indexOf('HOT') !== -1;
  var hasIce = typeUpper.indexOf('ICE') !== -1;
  _orderState.hasTempOption = hasHot || hasIce;
  _orderState.temp = hasHot ? 'HOT' : (hasIce ? 'ICE' : 'NONE');

  // 사이즈 옵션 상태 세팅
  _orderState.hasSizeOption   = !!hasSize;
  _orderState.sizeGrandeExtra = parseInt(grandeExtra || 0, 10);
  _orderState.sizeVentiExtra  = parseInt(ventiExtra  || 0, 10);
  _orderState.size = _orderState.hasSizeOption ? 'TALL' : 'NONE';

  document.getElementById('order-modal-item-name').textContent = name;

  // 온도 행(레이블+버튼) 표시 제어
  var tempRow   = document.getElementById('order-temp-row');
  var tempGroup = document.getElementById('order-temp-group');
  if (_orderState.hasTempOption) {
    tempRow.style.display   = '';
    tempGroup.style.display = 'flex';
    var hotBtn = document.querySelector('.order-temp-btn[data-temp="HOT"]');
    var iceBtn = document.querySelector('.order-temp-btn[data-temp="ICE"]');
    if (hotBtn) hotBtn.style.display = hasHot ? '' : 'none';
    if (iceBtn) {
      iceBtn.style.display = hasIce ? '' : 'none';
      // ICE 버튼 라벨: 추가금 있으면 "ICE +500원" 형태로 표시
      if (hasIce) {
        iceBtn.textContent = (_orderState.iceExtra > 0)
          ? 'ICE +' + _orderState.iceExtra.toLocaleString('ko-KR') + '원'
          : 'ICE';
      }
    }
    document.querySelectorAll('.order-temp-btn[data-temp]').forEach(function(btn) {
      btn.classList.toggle('active', btn.dataset.temp === _orderState.temp);
    });
  } else {
    tempRow.style.display = 'none';
  }

  // 사이즈 행 표시/라벨/기본 선택
  var sizeRow = document.getElementById('order-size-row');
  if (sizeRow) {
    if (_orderState.hasSizeOption) {
      sizeRow.style.display = '';
      var tallBtn   = document.querySelector('[data-size="TALL"]');
      var grandeBtn = document.querySelector('[data-size="GRANDE"]');
      var ventiBtn  = document.querySelector('[data-size="VENTI"]');
      if (tallBtn)   tallBtn.textContent   = 'TALL';
      if (grandeBtn) grandeBtn.textContent = _orderState.sizeGrandeExtra > 0
          ? 'GRANDE +' + _orderState.sizeGrandeExtra.toLocaleString('ko-KR') + '원' : 'GRANDE';
      if (ventiBtn)  ventiBtn.textContent  = _orderState.sizeVentiExtra > 0
          ? 'VENTI +'  + _orderState.sizeVentiExtra.toLocaleString('ko-KR')  + '원' : 'VENTI';
      document.querySelectorAll('[data-size]').forEach(function(btn) {
        btn.classList.toggle('active', btn.dataset.size === _orderState.size);
      });
    } else {
      sizeRow.style.display = 'none';
    }
  }

  _syncOrderUI();
  document.getElementById('order-modal').classList.add('open');

  // 포인트 영역 초기화 (로그인 사용자만 DOM 존재)
  var pBalEl = document.getElementById('order-points-balance');
  var pInpEl = document.getElementById('order-points-input');
  if (pBalEl && pInpEl) {
    var bal = window.userPointBalance || 0;
    pBalEl.textContent = bal.toLocaleString('ko-KR');
    pInpEl.value = '';
    pInpEl.max = bal;   // 브라우저 native 검증 보조
    _updateOrderPointsPreview();
  }
}

function closeOrderModal() {
  document.getElementById('order-modal').classList.remove('open');
  // 다음 메뉴 클릭 시 잔액이 깔끔하게 보이도록 포인트 입력 초기화
  var pInp = document.getElementById('order-points-input');
  if (pInp) pInp.value = '';
  var prev = document.getElementById('order-points-preview');
  if (prev) prev.style.display = 'none';
}

/** 온도 선택 — 합계 즉시 갱신 */
function selectTemp(temp) {
  _orderState.temp = temp;
  document.querySelectorAll('.order-temp-btn[data-temp]').forEach(function(btn) {
    btn.classList.toggle('active', btn.dataset.temp === temp);
  });
  _syncOrderUI();
}

/** 사이즈 선택 — 합계 즉시 갱신 */
function selectSize(size) {
  _orderState.size = size;
  document.querySelectorAll('[data-size]').forEach(function(btn) {
    btn.classList.toggle('active', btn.dataset.size === size);
  });
  _syncOrderUI();
}

/** 수량 변경 */
function changeQty(delta) {
  var next = _orderState.quantity + delta;
  if (next < 1 || next > 10) return;
  _orderState.quantity = next;
  _syncOrderUI();
}

/** HOT/ICE + 사이즈 + 수량 반영한 합계 계산 */
function _calcEffectivePrice() {
  var iceExtra  = (_orderState.temp === 'ICE') ? (_orderState.iceExtra || 0) : 0;
  var sizeExtra = (_orderState.size === 'GRANDE') ? (_orderState.sizeGrandeExtra || 0)
                : (_orderState.size === 'VENTI')  ? (_orderState.sizeVentiExtra  || 0)
                : 0;
  return _orderState.unitPrice + iceExtra + sizeExtra;
}

function _syncOrderUI() {
  document.getElementById('order-qty-val').textContent = _orderState.quantity;
  var total = _calcEffectivePrice() * _orderState.quantity;
  document.getElementById('order-total-price').textContent =
      total.toLocaleString('ko-KR') + '원';
  _updateOrderPointsPreview();
}

/** 옵션 모달 포인트 입력값을 검증해서 정수로 반환. 0 이면 미사용. -1 이면 검증 실패. */
function _validateOrderPointsInput() {
  var inpEl = document.getElementById('order-points-input');
  if (!inpEl) return 0;   // 비로그인 등 입력란 자체가 없는 경우

  var raw = (inpEl.value || '').trim();
  if (raw === '') return 0;

  var p = parseInt(raw, 10);
  if (isNaN(p) || p < 0) {
    showAlert('포인트는 0 이상의 숫자여야 합니다.', '입력 오류', 'error');
    return -1;
  }
  if (p === 0) return 0;
  if (p % 100 !== 0) {
    showAlert('포인트는 100P 단위로 사용해야 합니다.', '입력 오류', 'error');
    return -1;
  }
  if (p < 1000) {
    showAlert('포인트는 1,000P 이상부터 사용 가능합니다.', '입력 오류', 'error');
    return -1;
  }
  var bal = window.userPointBalance || 0;
  if (p > bal) {
    showAlert('포인트 잔액이 부족합니다. (보유: ' + bal.toLocaleString('ko-KR') + 'P)',
              '입력 오류', 'error');
    return -1;
  }
  var total = _calcEffectivePrice() * _orderState.quantity;
  if (p > total) {
    showAlert('사용 포인트가 결제 금액을 초과할 수 없습니다.', '입력 오류', 'error');
    return -1;
  }
  return p;
}

/** 포인트 사용 시 실 결제액 미리보기 갱신 */
function _updateOrderPointsPreview() {
  var inpEl = document.getElementById('order-points-input');
  var prevEl = document.getElementById('order-points-preview');
  var amtEl = document.getElementById('order-points-pay-amount');
  if (!inpEl || !prevEl || !amtEl) return;

  var raw = (inpEl.value || '').trim();
  var p = parseInt(raw, 10);
  if (isNaN(p) || p <= 0) {
    prevEl.style.display = 'none';
    return;
  }
  var total = _calcEffectivePrice() * _orderState.quantity;
  var pay = Math.max(0, total - p);
  amtEl.textContent = pay.toLocaleString('ko-KR') + '원';
  prevEl.style.display = '';
}

/** 전액 사용 버튼: min(잔액, 합계) 를 100P 단위 내림. 1,000P 미만이면 0 (사용 불가). */
function _useAllOrderPoints() {
  var inpEl = document.getElementById('order-points-input');
  if (!inpEl) return;
  var bal = window.userPointBalance || 0;
  var total = _calcEffectivePrice() * _orderState.quantity;
  var max = Math.min(bal, total);
  var rounded = Math.floor(max / 100) * 100;
  if (rounded < 1000) rounded = 0;
  inpEl.value = rounded > 0 ? rounded : '';
  _updateOrderPointsPreview();
}

/** 결제 진행 버튼 클릭 */
function startPayment(clientKey) {
  var base       = window.location.origin + (window.contextPath || '');
  var successUrl = base + '/order/success';
  var failUrl    = base + '/order/fail';

  var btn = document.getElementById('order-pay-btn');
  if (!btn.dataset.originalText) btn.dataset.originalText = btn.textContent;
  btn.disabled = true;
  btn.textContent = '처리 중...';

  var effectiveUnitPrice = _calcEffectivePrice();

  // 포인트 사용 검증 (로그인 사용자 한정 — 비로그인이면 입력란 자체가 없어 0 반환)
  var useP = _validateOrderPointsInput();
  if (useP === -1) {
    btn.disabled = false;
    btn.textContent = btn.dataset.originalText || '바로 결제';
    return;
  }

  var payload = {
    items: [{
      menuName:    _orderState.name,
      temperature: _orderState.temp,
      size:        _orderState.size,       // TALL / GRANDE / VENTI / NONE
      quantity:    _orderState.quantity,
      unitPrice:   effectiveUnitPrice      // ICE + 사이즈 추가금 반영 가격
    }],
    pointsToUse: useP                       // 0 이면 미사용
  };

  fetch('/order/create', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  })
  .then(function(res) {
    // 비로그인(401) → alert 없이 로그인 페이지로 자동 이동, 원 페이지로 복귀 처리
    if (res.status === 401) {
      var redirectTo = encodeURIComponent(location.pathname + location.search);
      location.href = '/member/login?redirect=' + redirectTo;
      return null;
    }
    return res.json().then(function(data) { return { data: data, status: res.status }; });
  })
  .then(function(result) {
    if (result === null) return;   // 로그인 페이지로 리다이렉트된 케이스
    var data = result.data;

    // 일부 환경에서는 200 + {error:"로그인이 필요합니다."} 로 내려올 수도 있음
    if (data && data.error === '로그인이 필요합니다.') {
      var redirectTo = encodeURIComponent(location.pathname + location.search);
      location.href = '/member/login?redirect=' + redirectTo;
      return;
    }

    if (data && data.error) {
      showAlert(data.error, '오류', 'error');
      btn.disabled = false;
      btn.textContent = btn.dataset.originalText || '바로 결제';
      return;
    }

    // TossPayments 결제창 호출
    var toss = TossPayments(clientKey);
    toss.requestPayment('카드', {
      amount:      data.amount,
      orderId:     data.orderId,
      orderName:   _orderState.name +
                   (_orderState.quantity > 1 ? ' 외 ' + (_orderState.quantity - 1) + '잔' : ''),
      customerName: window.customerName || '',
      successUrl:  successUrl,
      failUrl:     failUrl
    }).catch(function(err) {
      if (err.code !== 'USER_CANCEL') {
        showAlert('결제 오류: ' + err.message, '결제 실패', 'error');
      }
      btn.disabled = false;
      btn.textContent = btn.dataset.originalText || '바로 결제';
    });
  })
  .catch(function() {
    showAlert('주문 생성 중 오류가 발생했습니다.', '오류', 'error');
    btn.disabled = false;
    btn.textContent = btn.dataset.originalText || '바로 결제';
  });
}

// 모달 외부 클릭 닫기 + 포인트 입력 리스너 바인딩
document.addEventListener('DOMContentLoaded', function() {
  var overlay = document.getElementById('order-modal');
  if (overlay) {
    overlay.addEventListener('click', function(e) {
      if (e.target === overlay) closeOrderModal();
    });
  }
  var pInp = document.getElementById('order-points-input');
  if (pInp) {
    pInp.addEventListener('input', _updateOrderPointsPreview);
  }
  var pAllBtn = document.getElementById('order-points-all-btn');
  if (pAllBtn) {
    pAllBtn.addEventListener('click', _useAllOrderPoints);
  }
});

/** 옵션 모달의 "장바구니 담기" 버튼 → POST /cart/add */
function addToCartFromModal() {
  var cartBtn = document.getElementById('order-cart-btn');
  if (cartBtn) {
    if (!cartBtn.dataset.originalText) cartBtn.dataset.originalText = cartBtn.textContent;
    cartBtn.disabled = true;
    cartBtn.textContent = '담는 중...';
  }

  var form = new URLSearchParams();
  form.append('menuName',    _orderState.name);
  form.append('temperature', _orderState.temp || 'NONE');
  form.append('size',        _orderState.size || 'NONE');
  form.append('quantity',    _orderState.quantity);

  var ctx = window.contextPath || '';
  fetch(ctx + '/cart/add', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: form
  })
  .then(function(res) {
    // 비로그인 → 로그인 페이지로 (redirect 보존, 기존 order.js 패턴과 동일)
    if (res.status === 401) {
      var redirectTo = encodeURIComponent(location.pathname + location.search);
      location.href = (ctx || '') + '/member/login?redirect=' + redirectTo;
      return null;
    }
    return res.json().then(function(data) { return { status: res.status, data: data }; });
  })
  .then(function(result) {
    if (!result) return;
    if (result.status !== 200 || !result.data.success) {
      showAlert((result.data && result.data.error) || '장바구니 담기에 실패했습니다.', '오류', 'error');
    } else {
      showToast('장바구니에 담았습니다', 'success');
      if (typeof refreshBadge === 'function') refreshBadge();
      closeOrderModal();
    }
  })
  .catch(function() { showAlert('네트워크 오류가 발생했습니다.', '오류', 'error'); })
  .finally(function() {
    if (cartBtn) {
      cartBtn.disabled = false;
      cartBtn.textContent = cartBtn.dataset.originalText || '장바구니 담기';
    }
  });
}

/**
 * bfcache(뒤로가기)로 페이지가 복원될 때 옵션 모달의 결제/장바구니 버튼이
 * "처리 중..." / "담는 중..." + disabled 상태로 고정되는 것을 방지.
 * 예: 비로그인 → "바로 결제" 클릭 → /member/login 으로 이동 → 뒤로가기.
 */
function resetAllOrderButtons() {
  document.querySelectorAll('.order-pay-btn, .order-cart-btn').forEach(function(btn) {
    btn.disabled = false;
    var original = btn.dataset.originalText;
    if (original) btn.textContent = original;
  });
}
window.addEventListener('pageshow', function(event) {
  if (event.persisted) resetAllOrderButtons();
});
