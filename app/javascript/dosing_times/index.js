$(document).on('turbolinks:load', function(){
  $('#new-dosing_time-timeframe-select').change(function(){
    let time = $('#new-dosing_time-timeframe-select option:selected').data('time');

    let hourMinute = time.split(':');

    let hour = ( '00' + hourMinute[0]).slice( -2 );
    let minute = ( '00' + hourMinute[1]).slice( -2 );

    console.log(hour);
    console.log(minute);

    $('select[name="dosing_time[time(4i)]"]').val(hour);
    $('select[name="dosing_time[time(5i)]"]').val(minute);
  });
});
