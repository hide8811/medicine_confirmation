$(document).on('turbolinks:load', function() {
  let addError = function(elem, message) {
    $(elem).prevAll('label').addClass('error-label');
    $(elem).addClass('error-frame');
    $(elem).nextAll().last().text(message);
  }

  let removeError = function(elem) {
    $(elem).prevAll('label').removeClass('error-label');
    $(elem).removeClass('error-frame');
    $(elem).nextAll().last().text('');
  }

  $('form#care_receiver-form').keydown(function(e){
    let key = e.which
    if (key == 13) {
      e.preventDefault();
    };
  });

  $('#care_receiver-form-name input[type="text"]').blur(function() {
    if ($(this).val() === '') {
      addError(this, '入力してください');

    } else {
      removeError(this);
    }
  });

  $('#care_receiver-form-kana input[type="text"]').blur(function() {
    if ($(this).val() === '') {
      addError(this, '入力してください');

    } else if (!$(this).val().match(/^[ぁ-んー－]+$/)) {
      addError(this, 'ひらがなで入力してください');

    } else {
      removeError(this);
    }
  });

  $('#care_receiver-form-birthday select').blur(function() {
    if ($(this).val() === '') {
      addError(this, '選択してください');

    } else if ($(this).siblings('.error-frame').length >= 1) {
      $(this).removeClass('error-frame');

    } else {
      removeError(this);
    }
  });

  $('form#care_receiver-form').submit(function() {
    function mapFunc(index, elem) {
      let elemBlank = $(elem).val() === '';
      let inputElem = $(elem).prop('tagName') === 'INPUT'
      let selectElem = $(elem).prop('tagName') === 'SELECT'

      if (elemBlank && inputElem) {
        addError(elem, '入力してください');
        return elem;
      }

      if (elemBlank && selectElem) {
        addError(elem, '選択してください');
        return elem;
      }
    };

    let formErrors = $(this).find('input, select').map(mapFunc);

    if (formErrors.length >= 1) return false;
  });
});

