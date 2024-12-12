class Admins::CategoriesController < AdminController

  before_action :set_category, only: %i[show edit update destroy restore]

  def index
    if params[:show_deleted] == 'true'
      @categories = Category.with_deleted.order(created_at: :desc)
    else
      @categories = Category.order(created_at: :desc)
    end
  end

  def show
  end

  def edit
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admins_categories_path, notice: 'Category successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admins_categories_path, notice: 'Category successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      redirect_to admins_categories_path, notice: 'Category successfully soft deleted.'
    else
      redirect_to admins_categories_path, alert: @category.errors.full_messages.to_sentence
    end
  end

  def restore
    if @category
      @category.update(deleted_at: nil)
      redirect_to admins_categories_path, notice: 'Category successfully restored.'
    else
      redirect_to admins_categories_path, alert: 'Category not found.'
    end
  end

  private

  def set_category
    @category = Category.with_deleted.find_by(id: params[:id])
    unless @category
      redirect_to admins_categories_path, alert: 'Category not found.'
    end
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
