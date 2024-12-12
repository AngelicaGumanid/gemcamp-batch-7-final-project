class Admins::NewsTickersController < AdminController
  before_action :set_news_ticker, only: [:show, :edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.page(params[:page])
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin_id = current_admins_user.id

    if @news_ticker.save
      redirect_to admins_news_tickers_path, notice: 'News ticker was successfully created.'
    else
      render :new
    end
  end

  def edit
    @news_ticker = NewsTicker.find(params[:id])
  end

  def show
    @news_ticker = NewsTicker.find(params[:id])
  end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admins_news_tickers_path, notice: 'News ticker was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    redirect_to admins_news_tickers_path, notice: 'News ticker was successfully destroyed.'
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end
end
