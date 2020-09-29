$(document).on('turbolinks:load', function(){
  let errorMessageErase = function(t, form){
    t.removeClass('error-frame');
    t.prevAll('label').first().removeClass('error-label');

    form == 'input' ? t.next().remove('.error-message') : t.parent().next().remove('.error-message');
  };

  let addErrorMessage = function(t, form, id, message){
    t.addClass('error-frame');
    t.prevAll('label').first().addClass('error-label');

    if (form == 'input') {
      t.next().remove('.error-message');
      t.after(`<div id="${id}" class="error-message">${message}</div>`);

    } else {
      t.parent().next().remove('.error-message');
      t.parent().after(`<div id="${id}" class="error-message">${message}</div>`);
    };
  };

  $('form#care_receiver_form').keydown(function(e){
    let key = e.which
    if (key == 13) {
      e.preventDefault();
    };
  });

  $('#care_receiver-last_name').blur(function(){
    let lastNameInputField = $(this);

    if (lastNameInputField.val() == '') {
      addErrorMessage(lastNameInputField, 'input', 'last_name-error', '入力してください');

    } else {
      errorMessageErase(lastNameInputField, 'input');
    };
  });

  $('#care_receiver-first_name').blur(function(){
    let firstNameInputField = $(this);

    if (firstNameInputField.val() == '' ) {
      addErrorMessage(firstNameInputField, 'input', 'first_name-error', '入力してください');

    } else {
      errorMessageErase(firstNameInputField, 'input');
    };
  });

  $('#care_receiver-last_name_kana').blur(function(){
    let lastNameKanaInputField = $(this);

    if (lastNameKanaInputField.val() == '' ) {
      addErrorMessage(lastNameKanaInputField, 'input', 'last_name_kana-error', '入力してください');

    } else if (!lastNameKanaInputField.val().match(/^[ぁ-んー－]+$/)) {
      addErrorMessage(lastNameKanaInputField, 'input', 'last_name-hiragana_error', 'ひらがなで入力してください');

    } else {
      errorMessageErase(lastNameKanaInputField, 'input');
    };
  });

  $('#care_receiver-first_name_kana').blur(function(){
    let firstNameKanaInputField = $(this);

    if (firstNameKanaInputField.val() == '') {
      addErrorMessage(firstNameKanaInputField, 'input', 'first_name_kana-error', '入力してください');

    } else if (!firstNameKanaInputField.val().match(/^[ぁ-んー－]+$/)) {
      addErrorMessage(firstNameKanaInputField, 'input', 'first_name-hiragana_error', 'ひらがなで入力してください');

    } else {
      errorMessageErase(firstNameKanaInputField, 'input');
    };
  });

  $('#care_receiver_birthday_1i').blur(function(){
    let birthdaySelectYear = $(this);

    if (birthdaySelectYear.val() == '') {
      addErrorMessage(birthdaySelectYear, 'select', 'birthday-year-error', '選択してください');

    } else if (birthdaySelectYear.siblings('.error-frame').length) {
      birthdaySelectYear.removeClass('error-frame');

    } else {
      errorMessageErase(birthdaySelectYear, 'select');
    };
  });

  $('#care_receiver_birthday_2i').blur(function(){
    let birthdaySelectMonth = $(this);

    if (birthdaySelectMonth.val() == '') {
      addErrorMessage(birthdaySelectMonth, 'select', 'birthday-month-error', '選択してください');

    } else if (birthdaySelectMonth.siblings('.error-frame').length) {
      birthdaySelectMonth.removeClass('error-frame');

    } else {
      errorMessageErase(birthdaySelectMonth, 'select');
    };
  });

  $('#care_receiver_birthday_3i').blur(function(){
    let birthdaySelectDate = $(this);

    if (birthdaySelectDate.val() == '') {
      addErrorMessage(birthdaySelectDate, 'select', 'birthday-date-error', '選択してください');

    } else if (birthdaySelectDate.siblings('.error-frame').length) {
      birthdaySelectDate.removeClass('error-frame');

    } else {
      errorMessageErase(birthdaySelectDate, 'select');
    };
  });
});

