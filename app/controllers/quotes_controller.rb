class QuotesController < ApplicationController
  before_filter :authenticate, :only => [:destroy, :update, :create]
  # GET /quotes
  # GET /quotes.json
  def index
    if params[:user_id]
      @quotes = Quote.find_all_by_user_id(params[:user_id])
    else
      @quotes = Quote.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @quote = Quote.find(params[:id])
    @user = User.find(@quote.user_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.json
  def new
    @quote = Quote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(params[:quote])

    if @quote.user_id !=  @logged_user.id
      redirect_to :status => 401
    end

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render json: @quote, status: :created, location: @quote }
      else
        format.html { render action: "new" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quotes/1
  # PUT /quotes/1.json
  def update
    @quote = Quote.find(params[:id])

    if @quote.user_id !=  @logged_user.id
      render nothing:true, :status => 401
      return
    end

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end


  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      @logged_user = User.find_by_user_name(username)
      if @logged_user && @logged_user.authenticate(password)
        return true
      end
    end
    return false
  end
end
