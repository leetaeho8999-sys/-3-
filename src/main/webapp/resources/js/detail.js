function openDetail(card) {
    var modalImg = document.getElementById('modal-img');
    var modalPh  = document.getElementById('modal-img-placeholder');
    if (card.dataset.img) {
        modalImg.src = card.dataset.img;
        modalImg.alt = card.dataset.name;
        modalImg.style.display = 'block';
        if (modalPh) modalPh.style.display = 'none';
    } else {
        modalImg.style.display = 'none';
        if (modalPh) modalPh.style.display = 'flex';
    }
    var tag   = document.getElementById('modal-tag');
    var name  = document.getElementById('modal-name');
    var story = document.getElementById('modal-story');
    var price = document.getElementById('modal-price');
    if (tag)   tag.textContent   = card.dataset.type  || '';
    if (name)  name.textContent  = card.dataset.name  || '';
    if (story) story.textContent = card.dataset.story || '';
    if (price) {
        var priceNum = parseInt((card.dataset.price || '0').replace(/[^0-9]/g, ''), 10) || 0;
        price.textContent = priceNum.toLocaleString('ko-KR') + '원';
    }

    // 구매하기 버튼에 현재 카드 데이터 바인딩 (iceExtra + size 옵션 포함)
    var buyBtn = document.getElementById('btn-buy');
    if (buyBtn) {
        buyBtn.dataset.name       = card.dataset.name       || '';
        buyBtn.dataset.price      = card.dataset.price      || '';
        buyBtn.dataset.type       = card.dataset.type       || '';
        buyBtn.dataset.iceExtra   = card.dataset.iceExtra   || '0';
        buyBtn.dataset.sizeGrande = card.dataset.sizeGrande || '0';
        buyBtn.dataset.sizeVenti  = card.dataset.sizeVenti  || '0';
        buyBtn.dataset.hasSize    = card.dataset.hasSize    || 'false';
    }

    document.getElementById('detail-modal').classList.add('open');
}

function closeDetail() {
    var modal = document.getElementById('detail-modal');
    if (modal) modal.classList.remove('open');
}

/** 구매하기 클릭 → 주문 옵션 모달로 전환 */
function onBuyClick(btn) {
    closeDetail();
    var name        = btn.dataset.name     || '';
    var price       = btn.dataset.price    || '0';
    var type        = btn.dataset.type     || '';
    var iceExtra    = parseInt(btn.dataset.iceExtra   || '0', 10);
    var grandeExtra = parseInt(btn.dataset.sizeGrande || '0', 10);
    var ventiExtra  = parseInt(btn.dataset.sizeVenti  || '0', 10);
    var hasSize     = btn.dataset.hasSize === 'true';
    if (typeof openOrderModal === 'function') {
        openOrderModal(name, price, type, iceExtra, hasSize, grandeExtra, ventiExtra);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    var detailModal = document.getElementById('detail-modal');
    if (detailModal) {
        detailModal.addEventListener('click', function(e) {
            if (e.target === this) closeDetail();
        });
    }
});
