class Timeframe < ActiveHash::Base
  self.data = [
    { id: 1, name: '起床時', time: '6:00' },
    { id: 2, name: '朝食前', time: '7:00' },
    { id: 3, name: '朝食直前', time: '7:30' },
    { id: 4, name: '朝食直後', time: '8:00' },
    { id: 5, name: '朝食後', time: '8:30' },
    { id: 6, name: '食間(午前)', time: '10:00' },
    { id: 7, name: '昼食前', time: '11:30' },
    { id: 8, name: '昼食直前', time: '12:00' },
    { id: 9, name: '昼食直後', time: '12:30' },
    { id: 10, name: '昼食後', time: '13:00' },
    { id: 11, name: '食間(午後)', time: '15:00' },
    { id: 12, name: '夕食前', time: '18:30' },
    { id: 13, name: '夕食直前', time: '19:00' },
    { id: 14, name: '夕食直後', time: '19:30' },
    { id: 15, name: '夕食後', time: '20:00' },
    { id: 16, name: '食間(夜)', time: '22:00' },
    { id: 17, name: '就寝前', time: '23:00' },
    { id: 18, name: '頓服', time: '00:00' },
    { id: 19, name: 'その他', time: '00:00' }
  ]
end
