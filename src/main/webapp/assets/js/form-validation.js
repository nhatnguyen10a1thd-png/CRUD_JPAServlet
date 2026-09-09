/**
 * form-validation.js
 * Client-side Form Validation Library with Bootstrap 5 integration
 */
(function () {
    'use strict';

    const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const PHONE_REGEX = /^[0-9]{10,11}$/;
    const URL_REGEX = /^(https?:\/\/)[^\s/$.?#].[^\s]*$/i;
    const MAX_FILE_SIZE_BYTES = 5 * 1024 * 1024; // 5 MB
    const ALLOWED_IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif'];

    function getFeedbackElement(input) {
        let feedback = null;
        const wrapper = input.closest('.input-icon-wrapper') || input.closest('.input-group');
        if (wrapper) {
            feedback = wrapper.querySelector('.invalid-feedback') || wrapper.nextElementSibling;
            if (feedback && !feedback.classList.contains('invalid-feedback')) {
                feedback = null;
            }
        }
        if (!feedback) {
            let next = input.nextElementSibling;
            while (next) {
                if (next.classList && next.classList.contains('invalid-feedback')) {
                    feedback = next;
                    break;
                }
                next = next.nextElementSibling;
            }
        }
        if (!feedback && input.parentElement) {
            feedback = input.parentElement.querySelector('.invalid-feedback');
        }
        return feedback;
    }

    function setFieldError(input, message) {
        input.classList.remove('is-valid');
        input.classList.add('is-invalid');
        const feedback = getFeedbackElement(input);
        if (feedback) {
            if (message) {
                feedback.textContent = message;
            }
            feedback.style.display = 'block';
        }
    }

    function clearFieldError(input) {
        input.classList.remove('is-invalid');
        const feedback = getFeedbackElement(input);
        if (feedback) {
            feedback.style.display = '';
        }
    }

    function validateField(input) {
        if (input.disabled || input.readOnly || input.type === 'hidden') {
            return true;
        }

        const value = (input.value || '').trim();
        const rawValue = input.value || '';
        const isRequired = input.hasAttribute('required');

        // Check required
        if (isRequired) {
            if (input.type === 'file') {
                if (!input.files || input.files.length === 0) {
                    setFieldError(input, 'Vui lòng chọn một tệp.');
                    return false;
                }
            } else if (input.type === 'checkbox' || input.type === 'radio') {
                if (!input.checked) {
                    setFieldError(input, 'Vui lòng chọn trường này.');
                    return false;
                }
            } else if (!value) {
                setFieldError(input, input.getAttribute('data-error-required') || 'Vui lòng không để trống trường này.');
                return false;
            }
        }

        // If not required and empty, skip further format checks
        if (!isRequired && !value && input.type !== 'file') {
            clearFieldError(input);
            return true;
        }

        // Check minlength
        const minLength = input.getAttribute('minlength');
        if (minLength && value.length < parseInt(minLength, 10)) {
            setFieldError(input, `Tối thiểu ${minLength} ký tự (hiện có ${value.length} ký tự).`);
            return false;
        }

        // Check maxlength
        const maxLength = input.getAttribute('maxlength');
        if (maxLength && value.length > parseInt(maxLength, 10)) {
            setFieldError(input, `Tối đa ${maxLength} ký tự.`);
            return false;
        }

        // Check type="email"
        if (input.type === 'email' && value) {
            if (!EMAIL_REGEX.test(value)) {
                setFieldError(input, 'Địa chỉ email không đúng định dạng (ví dụ: user@example.com).');
                return false;
            }
        }

        // Check type="url"
        if (input.type === 'url' && value) {
            if (!URL_REGEX.test(value)) {
                setFieldError(input, 'URL phải bắt đầu bằng http:// hoặc https:// và có địa chỉ hợp lệ.');
                return false;
            }
        }

        // Check type="tel" or phone pattern
        if (input.type === 'tel' && value) {
            if (!PHONE_REGEX.test(value)) {
                setFieldError(input, 'Số điện thoại phải gồm 10 đến 11 chữ số.');
                return false;
            }
        }

        // Check pattern attribute
        const pattern = input.getAttribute('pattern');
        if (pattern && value) {
            const regex = new RegExp('^' + pattern + '$');
            if (!regex.test(rawValue)) {
                setFieldError(input, input.getAttribute('data-error-pattern') || 'Dữ liệu không đúng định dạng yêu cầu.');
                return false;
            }
        }

        // Check number min / max / step
        if (input.type === 'number' && value) {
            const num = parseFloat(value);
            if (isNaN(num)) {
                setFieldError(input, 'Giá trị phải là một số hợp lệ.');
                return false;
            }
            const min = input.getAttribute('min');
            if (min !== null && num < parseFloat(min)) {
                setFieldError(input, `Giá trị phải lớn hơn hoặc bằng ${min}.`);
                return false;
            }
            const max = input.getAttribute('max');
            if (max !== null && num > parseFloat(max)) {
                setFieldError(input, `Giá trị phải nhỏ hơn hoặc bằng ${max}.`);
                return false;
            }
            const step = input.getAttribute('step');
            if (step === '0.01') {
                const parts = value.split('.');
                if (parts.length > 1 && parts[1].length > 2) {
                    setFieldError(input, 'Chỉ được phép tối đa 2 chữ số thập phân.');
                    return false;
                }
            }
        }

        // Check password match (data-match="#password")
        const matchTargetSelector = input.getAttribute('data-match');
        if (matchTargetSelector) {
            const targetInput = document.querySelector(matchTargetSelector);
            if (targetInput && rawValue !== targetInput.value) {
                setFieldError(input, 'Mật khẩu xác nhận không khớp.');
                return false;
            }
        }

        // Check file uploads
        if (input.type === 'file' && input.files && input.files.length > 0) {
            const file = input.files[0];
            if (file.size > MAX_FILE_SIZE_BYTES) {
                setFieldError(input, 'Dung lượng tệp vượt quá giới hạn 5 MB.');
                return false;
            }
            const fileName = file.name || '';
            const dotIdx = fileName.lastIndexOf('.');
            if (dotIdx > -1) {
                const ext = fileName.substring(dotIdx + 1).toLowerCase();
                if (!ALLOWED_IMAGE_EXTENSIONS.includes(ext)) {
                    setFieldError(input, 'Chỉ chấp nhận các định dạng ảnh: JPG, PNG, GIF.');
                    return false;
                }
            }
        }

        // If everything is valid
        clearFieldError(input);
        return true;
    }

    function initFormValidation() {
        const forms = document.querySelectorAll('.needs-validation');

        forms.forEach((form) => {
            const inputs = form.querySelectorAll('input, select, textarea');

            inputs.forEach((input) => {
                input.addEventListener('input', () => {
                    if (input.classList.contains('is-invalid')) {
                        validateField(input);
                    }
                    const matchedInputs = form.querySelectorAll(`[data-match="#${input.id}"]`);
                    matchedInputs.forEach((matched) => {
                        if (matched.classList.contains('is-invalid') || matched.value) {
                            validateField(matched);
                        }
                    });
                });

                input.addEventListener('change', () => {
                    validateField(input);
                });

                input.addEventListener('blur', () => {
                    if (input.value || input.classList.contains('is-invalid')) {
                        validateField(input);
                    }
                });
            });

            form.addEventListener('submit', (event) => {
                let isFormValid = true;
                let firstInvalidElement = null;

                inputs.forEach((input) => {
                    const valid = validateField(input);
                    if (!valid) {
                        isFormValid = false;
                        if (!firstInvalidElement) {
                            firstInvalidElement = input;
                        }
                    }
                });

                if (!isFormValid) {
                    event.preventDefault();
                    event.stopPropagation();
                    if (firstInvalidElement) {
                        firstInvalidElement.focus();
                        firstInvalidElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            });
        });
    }

    window.FormValidator = {
        validateField,
        setFieldError,
        clearFieldError,
        init: initFormValidation
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initFormValidation);
    } else {
        initFormValidation();
    }
})();
