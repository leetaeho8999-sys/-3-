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
    if (price) price.textContent = card.dataset.price || '';
    document.getElementById('detail-modal').classList.add('open');
}

function closeDetail() {
    var modal = document.getElementById('detail-modal');
    if (modal) modal.classList.remove('open');
}

function showComingSoon() {
    closeDetail();
    var modal = document.getElementById('coming-soon-modal');
    if (modal) modal.classList.add('open');
}

function closeComingSoon() {
    var modal = document.getElementById('coming-soon-modal');
    if (modal) modal.classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function() {
    var detailModal = document.getElementById('detail-modal');
    if (detailModal) {
        detailModal.addEventListener('click', function(e) {
            if (e.target === this) closeDetail();
        });
    }
});
