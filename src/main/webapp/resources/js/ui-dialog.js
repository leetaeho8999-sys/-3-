/* =====================================================
   ui-dialog.js — window.showToast / showAlert / showConfirm
   브라우저 alert/confirm 대체 공통 모듈. 전 페이지에서 전역 사용 가능.

   API:
     showToast(message, type='success', options={ duration:3000 })
     showAlert(message, title='알림', type='info', options={ html:false })     → Promise<void>
     showConfirm(message, title='확인', options={
         confirmText:'확인', cancelText:'취소',
         dangerMode:false, html:false
     })                                                                      → Promise<boolean>

   선언형 확인: <a data-confirm="정말 삭제?" data-confirm-title="삭제 확인" data-confirm-danger>삭제</a>
   ===================================================== */

(function() {
    'use strict';

    // ─── 상수 ──────────────────────────────────────
    var TOAST_MAX   = 3;
    var TOAST_MS    = 3000;
    var TOAST_OUT   = 300;
    var DIALOG_OUT  = 150;

    var ICON_BY_TYPE = {
        success: '✅',
        info:    'ℹ️',
        warning: '⚠️',
        error:   '❌'
    };

    // ─── 토스트 컨테이너 lazy 생성 ─────────────────
    function getToastContainer() {
        var c = document.getElementById('ui-toast-container');
        if (!c) {
            c = document.createElement('div');
            c.id = 'ui-toast-container';
            c.className = 'ui-toast-container';
            document.body.appendChild(c);
        }
        return c;
    }

    function escapeHtml(str) {
        return String(str == null ? '' : str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    // ─── showToast ─────────────────────────────────
    function showToast(message, type, options) {
        type = type || 'success';
        options = options || {};
        var duration = options.duration || TOAST_MS;

        var container = getToastContainer();
        // 최대 3개 유지: 가장 오래된 것 즉시 제거
        while (container.children.length >= TOAST_MAX) {
            container.removeChild(container.firstChild);
        }

        var toast = document.createElement('div');
        toast.className = 'ui-toast ui-toast--' + type;
        var icon = ICON_BY_TYPE[type] || '';
        toast.innerHTML = (icon ? '<span class="ui-toast__icon">' + icon + '</span>' : '') +
                          '<span>' + escapeHtml(message) + '</span>';
        container.appendChild(toast);

        // enter 애니메이션
        requestAnimationFrame(function() { toast.classList.add('show'); });

        // 자동 사라짐
        setTimeout(function() {
            toast.classList.remove('show');
            toast.classList.add('hide');
            setTimeout(function() {
                if (toast.parentNode) toast.parentNode.removeChild(toast);
            }, TOAST_OUT);
        }, duration);
    }

    // ─── 공용 모달 생성 헬퍼 ──────────────────────
    function createDialog(opts) {
        // opts: { message, title, type, html, buttons: [{text, cls, value}], allowBackdropClose }
        var overlay = document.createElement('div');
        overlay.className = 'ui-dialog-overlay';

        var dialog = document.createElement('div');
        dialog.className = 'ui-dialog ui-dialog--' + (opts.type || 'info');

        // header
        var header = document.createElement('div');
        header.className = 'ui-dialog__header';
        var icon = ICON_BY_TYPE[opts.type] || ICON_BY_TYPE.info;
        header.innerHTML =
            '<span class="ui-dialog__icon">' + icon + '</span>' +
            '<h3 class="ui-dialog__title">' + escapeHtml(opts.title || '알림') + '</h3>';
        dialog.appendChild(header);

        // body
        var body = document.createElement('div');
        body.className = 'ui-dialog__body' + (opts.html ? ' ui-dialog__body--html' : '');
        if (opts.html) {
            body.innerHTML = opts.message || '';
        } else {
            body.textContent = opts.message || '';
        }
        dialog.appendChild(body);

        // footer
        var footer = document.createElement('div');
        footer.className = 'ui-dialog__footer';
        var btnElems = [];
        (opts.buttons || []).forEach(function(b) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'ui-btn ' + (b.cls || 'ui-btn--primary');
            btn.textContent = b.text;
            btn.dataset.value = b.value;
            footer.appendChild(btn);
            btnElems.push(btn);
        });
        dialog.appendChild(footer);

        overlay.appendChild(dialog);

        // body scroll lock
        var priorBodyOverflow = document.body.style.overflow;
        document.body.style.overflow = 'hidden';

        function close(value) {
            overlay.classList.add('hide');
            setTimeout(function() {
                if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
                document.body.style.overflow = priorBodyOverflow;
            }, DIALOG_OUT);
            document.removeEventListener('keydown', onKey);
            if (pending) pending(value);
        }

        var pending;
        function onKey(e) {
            if (e.key === 'Escape') {
                close(opts.escapeValue);
            }
        }
        document.addEventListener('keydown', onKey);

        btnElems.forEach(function(btn) {
            btn.addEventListener('click', function() {
                // data-value attribute is string; normalize to boolean for confirm
                var v = btn.dataset.value;
                if (v === 'true')  v = true;
                else if (v === 'false') v = false;
                close(v);
            });
        });

        if (opts.allowBackdropClose) {
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) close(opts.backdropValue);
            });
        }

        document.body.appendChild(overlay);
        // 포커스: primary 버튼 (마지막 버튼) 에 포커스
        if (btnElems.length) btnElems[btnElems.length - 1].focus();

        return new Promise(function(resolve) { pending = resolve; });
    }

    // ─── showAlert ─────────────────────────────────
    function showAlert(message, title, type, options) {
        options = options || {};
        return createDialog({
            message: message,
            title:   title || '알림',
            type:    type  || 'info',
            html:    !!options.html,
            allowBackdropClose: true,
            backdropValue: undefined,
            escapeValue:   undefined,
            buttons: [{ text: options.confirmText || '확인', cls: 'ui-btn--primary', value: true }]
        });
    }

    // ─── showConfirm ───────────────────────────────
    function showConfirm(message, title, options) {
        options = options || {};
        var dangerClass = options.dangerMode ? 'ui-btn--danger' : 'ui-btn--primary';
        return createDialog({
            message: message,
            title:   title || '확인',
            type:    options.dangerMode ? 'warning' : 'info',
            html:    !!options.html,
            allowBackdropClose: true,
            backdropValue: false,   // 배경 클릭 = 취소
            escapeValue:   false,   // ESC = 취소
            buttons: [
                { text: options.cancelText  || '취소', cls: 'ui-btn--secondary', value: false },
                { text: options.confirmText || '확인', cls: dangerClass,         value: true  }
            ]
        });
    }

    // ─── [data-confirm] 선언형 핸들러 ───────────────
    //   <a data-confirm="정말?" data-confirm-title="삭제 확인" data-confirm-danger data-confirm-text="삭제">...</a>
    //   <form data-confirm="정말?" ...>
    function wireDataConfirm(root) {
        root.addEventListener('click', function(e) {
            var el = e.target.closest('[data-confirm]');
            if (!el || el._uiConfirmInProgress) return;
            // form submit 버튼인 경우 form 이 실제 확인 대상
            var isSubmit = el.tagName === 'BUTTON' && el.type === 'submit';
            if (isSubmit) return;  // form 의 submit 이벤트에서 처리
            e.preventDefault();
            el._uiConfirmInProgress = true;
            var message = el.getAttribute('data-confirm');
            var title   = el.getAttribute('data-confirm-title') || '확인';
            var danger  = el.hasAttribute('data-confirm-danger');
            var cText   = el.getAttribute('data-confirm-text');
            showConfirm(message, title, {
                dangerMode: danger,
                confirmText: cText || (danger ? '삭제' : '확인')
            }).then(function(ok) {
                el._uiConfirmInProgress = false;
                if (!ok) return;
                if (el.tagName === 'A' && el.href) {
                    location.href = el.href;
                } else if (el.tagName === 'FORM') {
                    el.removeAttribute('data-confirm');  // 재확인 방지
                    el.submit();
                } else {
                    // button — 폼 내부면 폼 제출
                    var form = el.closest('form');
                    if (form) {
                        form.removeAttribute('data-confirm');
                        form.submit();
                    }
                }
            });
        }, true);

        root.addEventListener('submit', function(e) {
            var form = e.target.closest('form[data-confirm]');
            if (!form) return;
            if (form._uiConfirmDone) return; // 통과 후에는 기본 제출 허용
            e.preventDefault();
            var message = form.getAttribute('data-confirm');
            var title   = form.getAttribute('data-confirm-title') || '확인';
            var danger  = form.hasAttribute('data-confirm-danger');
            var cText   = form.getAttribute('data-confirm-text');
            showConfirm(message, title, {
                dangerMode: danger,
                confirmText: cText || (danger ? '삭제' : '확인')
            }).then(function(ok) {
                if (!ok) return;
                form._uiConfirmDone = true;
                form.submit();
            });
        }, true);
    }

    // ─── 전역 노출 + 초기화 ──────────────────────
    window.showToast   = showToast;
    window.showAlert   = showAlert;
    window.showConfirm = showConfirm;

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() { wireDataConfirm(document); });
    } else {
        wireDataConfirm(document);
    }
})();
