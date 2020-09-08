$(document).on('turbolinks:load', function(){

  $('#user-employee').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>社員IDを入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#user-password').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>パスワードを入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#user-confirmation-password').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>パスワード(確認)を入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#user-last-name').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>名字を入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#user-first-name').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>名前を入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#user-last-name-kana').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>みょうじを入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#user-first-name-kana').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>なまえを入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  $('#new-user').submit(function() {
    if ($('div').hasClass('error-message')) {
      return false;
    };
  });
});
