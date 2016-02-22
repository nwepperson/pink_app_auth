describe User do
  user = User.create(
    email: 'nepperson@gmail.com',
    id: '1',
    first_name: 'anon',
    last_name: 'imous',
    password: 'Lucky123',
    password_confirmation: 'Lucky123') # creating a new user 'instance'

  it "has an email" do # yep, you can totally use 'it'
    expect(user.email).to be_truthy # this is our expectation
  end

  it "has an id" do # yep, you can totally use 'it'
    expect(user.id).to be_truthy # this is our expectation
  end

  it "has a first name" do # yep, you can totally use 'it'
    expect(user.first_name).to be_truthy # this is our expectation
  end

  it "has a last name" do # yep, you can totally use 'it'
    expect(user.last_name).to be_truthy # this is our expectation
  end

  it "is not admin" do
    @controller = UsersController.new
    @controller.instance_eval{ set_admin(user) }
    expect(@controller.instance_eval{ set_admin(user) }).to be false
  end
end
