var _currentOrderId = null;

function openOrderDetail(orderId) {
  _currentOrderId = orderId;
  fetch(getCtxPath() + '/order/detail/' + orderId)
    .then(function(res) {
      if (!res.ok) throw new Error(res.status);
      return res.json();
    })
    .then(function(data) {
      renderOrderModal(data);
      document.getElementById('order-detail-modal').style.display = 'flex';
      document.body.style.overflow = 'hidden';
    })
    .catch(function() {
      showAlert('주문 정보를 불러올 수 없습니다.', '오류', 'error');
    });
}

function closeOrderDetail() {
  document.getElementById('order-detail-modal').style.display = 'none';
  document.body.style.overflow = '';
  _currentOrderId = null;
}

function renderOrderModal(data) {
  var order = data.order || {};
  var items = data.items || [];
  document.getElementById('od-order-id').textContent    = order.orderId || '—';
  document.getElementById('od-reg-date').textContent    = order.regDate  || '—';
  document.getElementById('od-paid-date').textContent   = order.paidDate || '—';
  document.getElementById('od-payment-key').textContent = order.paymentKey || '—';
  document.getElementById('od-total').textContent       = (order.totalAmount || 0).toLocaleString() + '원';

  var statusEl = document.getElementById('od-status');
  var s = (order.status || '').toUpperCase();
  statusEl.textContent = s;
  statusEl.className = 'mp-order-status mp-order-status--' + s.toLowerCase();

  var tbody = document.getElementById('od-item-tbody');
  tbody.innerHTML = '';
  items.forEach(function(item) {
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td>' + escHtml(item.menuName) + '</td>' +
      '<td>' + escHtml(item.temperature) + '</td>' +
      '<td>' + escHtml(item.size || '—') + '</td>' +
      '<td>' + item.quantity + '</td>' +
      '<td>' + (item.unitPrice || 0).toLocaleString() + '원</td>' +
      '<td>' + (item.subtotal  || 0).toLocaleString() + '원</td>';
    tbody.appendChild(tr);
  });

  renderCancelSection(data);
}

/** 주문 상태별로 취소 섹션 / 취소 완료 섹션 토글 */
function renderCancelSection(data) {
  var order           = data.order || {};
  var canceledBox     = document.getElementById('canceled-info');
  var cancelBox       = document.getElementById('cancel-section');
  var previewRow      = document.getElementById('refund-preview-row');
  var tooLateBox      = document.getElementById('refund-too-late');
  var formBox         = document.getElementById('cancel-form');

  // 1) 이미 취소된 주문
  if ((order.status || '').toUpperCase() === 'CANCELLED') {
    canceledBox.style.display = '';
    cancelBox.style.display   = 'none';
    document.getElementById('ci-reason').textContent = reasonLabel(order.cancelReason);
    document.getElementById('ci-date').textContent   = order.cancelDate || '—';
    document.getElementById('ci-amount').textContent = (order.refundAmount || 0).toLocaleString() +
                                                       '원 (' + (order.refundRate || 0) + '%)';
    document.getElementById('ci-memo').textContent   = order.cancelMemo || '—';
    return;
  }

  // 2) PAID 상태 아니면 취소 UI 전체 숨김
  canceledBox.style.display = 'none';
  if ((order.status || '').toUpperCase() !== 'PAID') {
    cancelBox.style.display = 'none';
    return;
  }

  // 3) PAID + 환불 미리보기 렌더링
  cancelBox.style.display = '';
  var rate   = data.currentRefundRate   || 0;
  var amount = data.currentRefundAmount || 0;

  if (data.cancelable) {
    previewRow.style.display = '';
    tooLateBox.style.display = 'none';
    formBox.style.display    = '';
    document.getElementById('refund-preview').textContent =
        amount.toLocaleString() + '원 (' + rate + '%)';
    // 폼 초기화
    document.getElementById('cancel-reason').value = '';
    var memo = document.getElementById('cancel-memo');
    memo.value = '';
    memo.style.display = 'none';
  } else {
    // 10분 초과 — 취소 불가
    previewRow.style.display = 'none';
    formBox.style.display    = 'none';
    tooLateBox.style.display = '';
  }
}

/** 취소 사유 코드 → 한글 라벨 */
function reasonLabel(code) {
  switch ((code || '').toUpperCase()) {
    case 'CHANGE_MIND': return '단순 변심';
    case 'WRONG_ORDER': return '주문 실수';
    case 'TOO_SLOW':    return '조리 지연';
    case 'ETC':         return '기타';
    default:            return code || '—';
  }
}

/** 취소 버튼 클릭 → 환불률 재조회 → 최신값으로 확인 → POST /order/cancel */
async function cancelOrder() {
  if (!_currentOrderId) return;

  // 1) 사유 검증
  var reason = document.getElementById('cancel-reason').value;
  if (!reason) { showToast('취소 사유를 선택해주세요.', 'info'); return; }

  var memo = document.getElementById('cancel-memo').value;
  if (reason === 'ETC' && !memo.trim()) {
    showToast('기타 사유를 입력해주세요.', 'info');
    return;
  }

  // 2) 환불률 재조회 — 모달 열린 시점과 지금 사이에 구간이 넘어갔을 수 있음
  //    (서버는 어차피 취소 순간 기준으로 재계산하므로, UI 도 "지금" 기준으로 보여줘야 "속은 느낌" 제거)
  var preview;
  try {
    var previewRes = await fetch(getCtxPath() + '/order/detail/' + _currentOrderId);
    if (!previewRes.ok) throw new Error(previewRes.status);
    preview = await previewRes.json();
  } catch (err) {
    showAlert('환불 정보를 확인할 수 없습니다. 잠시 후 다시 시도해주세요.', '오류', 'error');
    return;
  }

  if (!preview.cancelable) {
    await showAlert('취소 가능 시간이 지났습니다. 페이지를 새로고침합니다.',
                    '취소 불가', 'warning');
    location.reload();
    return;
  }

  var rate   = preview.currentRefundRate   || 0;
  var amount = preview.currentRefundAmount || 0;

  // 3) 최신 환불률을 명시한 확인 다이얼로그 (HTML 포맷)
  var confirmHtml =
      '<div style="font-size:1.05rem;font-weight:600;margin-bottom:8px;color:#4a2c2a">' +
          '환불 금액: <span style="color:#b23a2e">' + amount.toLocaleString() + '원 (' + rate + '%)</span>' +
      '</div>' +
      '<div style="font-size:.88rem;color:#666;line-height:1.7">' +
          '※ 이 금액은 <b>"주문 취소"</b> 버튼을 누르는 시점을 기준으로 확정됩니다.<br>' +
          '※ 취소 후에는 복원할 수 없습니다.' +
      '</div>';
  var ok = await showConfirm(confirmHtml, '주문 취소 확인', {
      html: true, dangerMode: true, confirmText: '주문 취소'
  });
  if (!ok) return;

  // 4) 실제 취소 API
  try {
    var form = new URLSearchParams();
    form.append('orderId', _currentOrderId);
    form.append('reason',  reason);
    form.append('memo',    memo || '');

    var res = await fetch(getCtxPath() + '/order/cancel', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: form
    });
    var data = await res.json();

    if (data.success) {
      var completeHtml =
          '<div style="font-size:1rem;font-weight:600;margin-bottom:6px;color:#3a7d44">' +
              '환불 금액: ' + data.refundAmount.toLocaleString() + '원 (' + data.refundRate + '%)' +
          '</div>' +
          '<div style="font-size:.88rem;color:#666">영업일 기준 2~5일 내 카드사로 환불됩니다.</div>';
      await showAlert(completeHtml, '취소 완료', 'success', { html: true });
      location.reload();
    } else {
      showAlert(data.message || '취소 처리 중 오류가 발생했습니다.', '오류', 'error');
    }
  } catch (err) {
    showAlert('네트워크 오류가 발생했습니다.', '오류', 'error');
  }
}

/** "기타" 선택 시 textarea 노출/필수화 */
document.addEventListener('change', function(e) {
  if (e.target && e.target.id === 'cancel-reason') {
    var memo = document.getElementById('cancel-memo');
    if (!memo) return;
    memo.style.display = (e.target.value === 'ETC') ? '' : 'none';
    if (e.target.value !== 'ETC') memo.value = '';
  }
});

function escHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function getCtxPath() {
  return window.ctxPath || '';
}

document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') closeOrderDetail();
});
