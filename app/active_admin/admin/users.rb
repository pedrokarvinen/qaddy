ActiveAdmin.register User do
  menu :priority => 2

  config.sort_order = "created_at_desc"

  filter :name
  filter :email
  filter :created_at
  filter :updated_at

  scope :all, :default => true
  scope :admin
  scope :non_admin

  index do
    selectable_column
    column :name, sortable: :name do |user|
      link_to user.name, admin_user_path(user)
    end
    column :email
    column("Admin", sortable: :admin) { |user| status_tag("Admin", :ok) unless !user.admin? }
    column :created_at
  end

  show do |user|
    attributes_table do
      row :id
      row :name
      row :email
      row :created_at
      row :updated_at
      row :admin do
        if user.admin
          status_tag("Yes", :ok)
        else
          status_tag("No")
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :email
      f.input :no_password, as: :hidden, input_html: { value: "1" }
    end
    f.actions
  end

end
