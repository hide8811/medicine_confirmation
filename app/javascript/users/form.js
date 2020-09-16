$(document).on('turbolinks:load', function(){

  let errorMessageErase = function(t){
    t.prev().remove('.error-message');
    t.removeClass('error-frame');
  };

  let addErrorMessage = function(t, id, message){
    t.before(`<div id="${id}" class="error-message">${message}</div>`);
    t.addClass('error-frame');
  }

  $('form#new-user').keydown(function(e){
    let key = e.which
    if (key == 13) {
      e.preventDefault();
    }
  });

  $('#user-employee').blur(function(){
    let employeeInputField = $(this);
    errorMessageErase(employeeInputField);

    if (employeeInputField.val() == '') {
      addErrorMessage(employeeInputField, 'employee-presence-error', '社員IDを入力してください');

    } else {

      $.ajax({
        type: 'GET',
        url: 'employee_uniquness',
        data: { employee: employeeInputField.val() },
        dataType: 'json'

      }).done(function(data){

        if (data) {
          addErrorMessage(employeeInputField, 'employee-uniquness-error', 'その社員IDはすでに使用されています');
        };
      });
    };
  });

  $('#user-password').blur(function(){
    let passwordInputField = $(this);
    errorMessageErase(passwordInputField);

    if (passwordInputField.val() == '') {
      addErrorMessage(passwordInputField, 'password-presence-error', 'パスワードを入力してください');

    } else {

      if (passwordInputField.val().length < 8) {
        addErrorMessage(passwordInputField, 'password-max-length-error', '8文字以上で入力してください');

      } else if (passwordInputField.val().length > 16) {
        addErrorMessage(passwordInputField, 'password-min-length-error', '16文字以下で入力してください');

      } else  {

        if (passwordInputField.val().match(/[^A-Za-z\d]/)) {
          addErrorMessage(passwordInputField, 'password-non-caracter-error', '半角英数字以外は使用できません');

        } else if (!passwordInputField.val().match(/[A-Z]/)) {
          addErrorMessage(passwordInputField, 'password-upper-case-error', '"英大文字"を含めてください');

        } else if (!passwordInputField.val().match(/[a-z]/)) {
          addErrorMessage(passwordInputField, 'password-lower-case-error', '"英小文字"を含めてください');

        } else if (!passwordInputField.val().match(/\d/)) {
          addErrorMessage(passwordInputField, 'password-number-error', '"数字"を含めてください');
        };
      };
    };
  });

  $('#user-confirmation-password').blur(function(){
    let confimationPasswordInputField = $(this);
    errorMessageErase(confimationPasswordInputField);

    if (confimationPasswordInputField.val() == '') {
      addErrorMessage(confimationPasswordInputField, 'confirmation-password-presence-error', 'パスワード(確認)を入力してください');

    } else {

      if (confimationPasswordInputField.val() !== $('#user-password').val()) {
        addErrorMessage(confimationPasswordInputField, 'confirmation-password-mismatch-error', 'パスワードを確認してください');
      };
    };
  });

  $('#user-last-name').blur(function(){
    let lastNameInputField = $(this);
    errorMessageErase(lastNameInputField);

    if (lastNameInputField.val() == '') {
      addErrorMessage(lastNameInputField, 'last-name-presence-error', '名字を入力してください');
    };
  });

  $('#user-first-name').blur(function(){
    let firstNameInputField = $(this);
    errorMessageErase(firstNameInputField);

    if (firstNameInputField.val() == '') {
      addErrorMessage(firstNameInputField, 'first-name-presence-error', '名前を入力してください');
    };
  });

  $('#user-last-name-kana').blur(function(){
    let lastNameKanaInputField = $(this);
    errorMessageErase(lastNameKanaInputField);

    if (lastNameKanaInputField.val() == '') {
      addErrorMessage(lastNameKanaInputField, 'last-name-kana-presence-error', 'みょうじを入力してください');

    } else if (!lastNameKanaInputField.val().match(/^[ぁ-んー－]+$/)) {
      addErrorMessage(lastNameKanaInputField, 'last-name-hiragana-error', 'みょうじはひらがなで入力してください');
    };
  });

  $('#user-first-name-kana').blur(function(){
    let firstNameKanaInputField = $(this);
    errorMessageErase(firstNameKanaInputField);

    if (firstNameKanaInputField.val() == '') {
      addErrorMessage(firstNameKanaInputField, 'first-name-kana-presence-error', 'なまえを入力してください');

    } else if (!firstNameKanaInputField.val().match(/^[ぁ-んー－]+$/)) {
      addErrorMessage(firstNameKanaInputField, 'first-name-hiragana-error', 'なまえはひらがなで入力してください');
    };
  });

  $('#new-user').submit(function() {
    if ($('div').hasClass('error-message')) {
      let errorPosition = $('.error-frame').offset().top
      let windowHalf = $(window).height() / 2
      $('html, body').animate({scrollTop:(errorPosition - windowHalf)})
      return false;
    };

    if (
        $('#user-employee').val() == '' ||
        $('#user-password').val() == '' ||
        $('#user-confirmation-password').val() == '' ||
        $('#user-last-name').val() == '' ||
        $('#user-first-name').val() == '' ||
        $('#user-last-name-kana').val() == '' ||
        $('#user-first-name-kana').val() == ''
      ) {
      return false;
    }
  });
});
