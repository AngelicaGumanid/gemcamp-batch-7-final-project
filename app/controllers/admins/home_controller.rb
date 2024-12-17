class Admins::HomeController < AdminController
  layout 'admin'

  def index
    @recent_orders = Order.where(created_at: 7.days.ago..Time.now)
                          .order(created_at: :desc)
                          .limit(8)

    @items_with_min_tickets = Item
                                .left_joins(:tickets)
                                .select("items.*,
                                         items.batch_count AS current_batch,
                                         COUNT(tickets.id) AS tickets_sold_in_current_batch")
                                .where(status: 1)
                                .group("items.id, items.batch_count")
                                .order(created_at: :desc)
                                .having("COUNT(tickets.id) >= items.minimum_tickets OR COUNT(tickets.id) = 0") # Only display items with current batch tickets or no tickets sold yet.
                                .limit(5)

    @recent_items = Item.order(created_at: :desc).limit(10)
    @recent_news_tickers = NewsTicker.order(created_at: :desc).limit(5)
  end
end
