describe Appointment do
  appointment = Appointment.create(
    date: '2016-1-31',
    time: '15:00:00',
    comment: 'Testing rspec!')

  it 'has a date' do
    expect(appointment.date).to be_truthy
  end

  it 'has a time' do
    expect(appointment.time).to be_truthy
  end

  it 'has a comment' do
    expect(appointment.comment).to be_truthy
  end
end
