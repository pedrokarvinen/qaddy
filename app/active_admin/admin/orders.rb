ActiveAdmin.register Order do
  menu :priority => 5

  config.sort_order = "created_at_desc"

  actions :all, :except => :new

  # Customize filters
  filter :webstore, collection: Webstore.order("LOWER(name) asc")
  filter :number
  filter :total
  filter :customer_email
  filter :customer_name
  filter :send_email_at
  filter :internal_comment
  filter :discount_code
  filter :discount_code_perc
  filter :tracking_url_params
  filter :created_at
  filter :updated_at

  # scopes
  scope :all, :default => true
  scope :no_discount_code
  scope :no_discount_perc

  # Customize index screen
  index do
    selectable_column
    column :number, sortable: :number do |order|
      link_to order.number, admin_order_path(order)
    end
    column :webstore
    column :total
    column :customer_email
    column "Items" do |order|
      order.order_items.count
    end
    column :discount_code
    column "Discount %" do |order|
      order.discount_code_perc
    end
    column :created_at
  end

  # Customize show screen
  show do |order|
    attributes_table do
      row :id
      row :webstore
      row :number
      row :total
      row :customer_email
      row :customer_name
      row :send_email_after_hours
      row :send_email_at
      row :internal_comment
      row :discount_code
      row :discount_code_perc
      row :tracking_url_params
      row :created_at
      row :updated_at
    end

    panel "Order items" do
      table_for order.order_items do
        column :name
        column :description
        column :page_url
        column :image_url
        column :default_sharing_text
        column :qty
        column :total
      end
    end

    active_admin_comments
  end

  # Customize the form
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Order details" do
      f.input :webstore, as: :select, input_html: { disabled: true }
      f.input :number
      f.input :total
      f.input :customer_email
      f.input :customer_name
      f.input :send_email_after_hours
      f.input :send_email_at
      f.input :internal_comment
      f.input :discount_code
      f.input :discount_code_perc
      f.input :tracking_url_params
    end

    f.has_many :order_items do |oi_f|
      oi_f.inputs "Order item" do
        oi_f.input :name
        oi_f.input :description
        oi_f.input :page_url
        oi_f.input :image_url
        oi_f.input :default_sharing_text
        oi_f.input :qty
        oi_f.input :total
        if !oi_f.object.nil?
          # show the destroy checkbox only if it is an existing appointment
          # else, there's already dynamic JS to add / remove new appointments
          oi_f.input :_destroy, :as => :boolean, :label => "Destroy?"
        end
      end
    end

    f.actions
  end

  # custom member actions
  member_action :send_sharing_email, method: :put do
    @order = Order.find(params[:id])
    begin
      @mail = ShareMailer.order(@order, params[:order][:customer_email]).deliver
    rescue
      redirect_to admin_order_path(@order), alert: "Cannot send email. Missing images?"
      return
    end
    redirect_to admin_order_path(@order), notice: "Email sent to #{params[:order][:customer_email]}"
  end

  # sidebars
  sidebar :send_sharing_email, only: :show

end
