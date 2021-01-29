$(document).on('turbolinks:load', function(){

  let addErrorToDosingTime = function(area, message) {
    $('#new-dosing_time-error-message').append(`${message}を選択してください<br>`);
    area.addClass('error-frame');
  };

  $('#new-dosing_time-form').submit(function() {
    let timeframeSelector = $('select[name="dosing_time[timeframe_id]"]');
    let hourSelector = $('select[name="dosing_time[time(4i)]"]');
    let minuteSelector = $('select[name="dosing_time[time(5i)]"]');

    $('#new-dosing_time-error-message').text('');

    if (timeframeSelector.val() == '') {
      addErrorToDosingTime(timeframeSelector, '時間帯');

    } else {
      timeframeSelector.removeClass('error-frame');
    };

    if (hourSelector.val() == '') {
      addErrorToDosingTime(hourSelector, '時間(時)');

    } else {
      hourSelector.removeClass('error-frame');
    };

    if (minuteSelector.val() == '') {
      addErrorToDosingTime(minuteSelector, '時間(分)');

    } else {
      minuteSelector.removeClass('error-frame');
    };

    if ($(this).find('*').hasClass('error-frame')) {
      return false;
    };
  });

  $('select[name="dosing_time[timeframe_id]"]').change(function() {
    let hourSelector = $('select[name="dosing_time[time(4i)]"]');
    let minuteSelector = $('select[name="dosing_time[time(5i)]"]');
    let time = $(this).children(':selected').data('time');

    if ($(this).val() != '') {
      let hourMinute = time.split(':');
      let hour = ( '00' + hourMinute[0]).slice( -2 );
      let minute = ( '00' + hourMinute[1]).slice( -2 );

      $('#new-dosing_time-error-message').text('');
      $(this).add(hourSelector).add(minuteSelector).removeClass('error-frame');

      hourSelector.val(hour);
      minuteSelector.val(minute);
    };
  });

  $('select[name="dosing_time[time(4i)]"]').change(function() {

    if ($(this).val() != '') {
      let errorMessage =$('#new-dosing_time-error-message').html()
      let newErrorMessage = errorMessage.replace(/時間\(時\)を選択してください<br>/g, '');

      $('#new-dosing_time-error-message').html(newErrorMessage);
      $(this).removeClass('error-frame');
    };
  });

  $('select[name="dosing_time[time(5i)]"]').change(function() {

    if ($(this).val() != '') {
      let errorMessage =$('#new-dosing_time-error-message').html()
      let newErrorMessage = errorMessage.replace(/時間\(分\)を選択してください<br>/g, '');

      $('#new-dosing_time-error-message').html(newErrorMessage);
      $(this).removeClass('error-frame');
    };
  });

  $('.new-medicine_dosing_time-form').submit(function() {
    if ($(this).find('select[name="medicine_dosing_time[medicine_id]"]').val() == '') {
      $(this).children('.new-medicine_dosing_time__error-area').text('薬を選択してください');
      $(this).find('select[name="medicine_dosing_time[medicine_id]"]').addClass('error-frame');

      return false;
    };
  });

  $('select[name="medicine_dosing_time[medicine_id]"]').change(function() {
    $(this).parent().nextAll('.new-medicine_dosing_time__error-area').text('');
    $(this).removeClass('error-frame');
  });
});
