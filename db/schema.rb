# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 20_250_508_212_207) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'addresses', force: :cascade do |t|
    t.string 'line1', null: false
    t.string 'line2'
    t.string 'city'
    t.string 'county'
    t.string 'postcode'
    t.string 'country', default: 'UK', null: false
    t.bigint 'user_id'
    t.index ['user_id'], name: 'index_addresses_on_user_id'
  end

  create_table 'bookings', force: :cascade do |t|
    t.bigint 'member_id', null: false
    t.bigint 'class_schedule_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'payment_intent_id'
    t.integer 'payment_status', default: 0
    t.datetime 'paid_at'
    t.index ['class_schedule_id'], name: 'index_bookings_on_class_schedule_id'
    t.index ['member_id'], name: 'index_bookings_on_member_id'
  end

  create_table 'class_schedules', force: :cascade do |t|
    t.datetime 'date_time', null: false
    t.integer 'duration', null: false
    t.integer 'capacity', null: false
    t.bigint 'exercise_class_id', null: false
    t.bigint 'trainer_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.decimal 'price', precision: 10, scale: 2
    t.index ['exercise_class_id'], name: 'index_class_schedules_on_exercise_class_id'
    t.index ['trainer_id'], name: 'index_class_schedules_on_trainer_id'
  end

  create_table 'delayed_jobs', force: :cascade do |t|
    t.integer 'priority', default: 0, null: false
    t.integer 'attempts', default: 0, null: false
    t.text 'handler', null: false
    t.text 'last_error'
    t.datetime 'run_at'
    t.datetime 'locked_at'
    t.datetime 'failed_at'
    t.string 'locked_by'
    t.string 'queue'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index %w[priority run_at], name: 'delayed_jobs_priority'
  end

  create_table 'employees', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_employees_on_user_id'
  end

  create_table 'exercise_classes', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'members', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'stripe_customer_id'
    t.string 'stripe_subscription_id'
    t.datetime 'subscription_period_end'
    t.string 'default_payment_method_id'
    t.integer 'plan', default: 0, null: false
    t.boolean 'public_profile', default: false
    t.index ['stripe_customer_id'], name: 'index_members_on_stripe_customer_id', unique: true
    t.index ['user_id'], name: 'index_members_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'username', null: false
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.string 'first_name'
    t.string 'last_name'
    t.date 'date_of_birth'
    t.string 'phone_number'
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['username'], name: 'index_users_on_username', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'addresses', 'users'
  add_foreign_key 'bookings', 'class_schedules'
  add_foreign_key 'bookings', 'members'
  add_foreign_key 'class_schedules', 'employees', column: 'trainer_id'
  add_foreign_key 'class_schedules', 'exercise_classes'
  add_foreign_key 'employees', 'users'
  add_foreign_key 'members', 'users'
end
