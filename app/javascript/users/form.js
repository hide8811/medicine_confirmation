$(document).on('turbolinks:load', function(){

  // 社員ID
  $('#user-employee').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>社員IDを入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // 重複エラー
  });

  // パスワード
  $('#user-password').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>パスワードを入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // 文字数制限エラー 8文字以上
    if ($(this).val().length < 8 && !$(this).prev().hasClass('error-message')) {
      $(this).before(`<div id='max-length-error' class='error-message'>8文字以上で入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // 文字数制限エラー 16文字以下
    if ($(this).val().length > 16 && !$(this).prev().hasClass('error-message')) {
      $(this).before(`<div id='min-length-error' class='error-message'>16文字以下で入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // 使用文字エラー 半角英大小数字以外

    // 使用文字エラー 半角英大文字

    // 使用文字エラー 半角英小文字

    // 使用文字エラー 半角数字
  });

  // パスワード(確認)
  $('#user-confirmation-password').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>パスワード(確認)を入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // パスワード不一致エラー
  });

  // 名字
  $('#user-last-name').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>名字を入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  // 名前
  $('#user-first-name').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>名前を入力してください</div>`);
      $(this).addClass('error-frame');
    };
  });

  // みょうじ
  $('#user-last-name-kana').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>みょうじを入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // 使用文字エラー 平仮名のみ
  });

  // なまえ
  $('#user-first-name-kana').blur(function(){
    $(this).prev().remove('.error-message');
    $(this).removeClass('error-frame');

    // 未入力エラー
    if ($(this).val() == '') {
      $(this).before(`<div id='presence-error' class='error-message'>なまえを入力してください</div>`);
      $(this).addClass('error-frame');
    };

    // 使用文字エラー 平仮名のみ
  });

  // 新規登録ボタン
  $('#new-user').submit(function() {
    if ($('div').hasClass('error-message')) {
      return false;
    };
  });
});
