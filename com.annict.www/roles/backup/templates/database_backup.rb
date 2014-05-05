# encoding: utf-8

##
# Backup Generated: database_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t database_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://meskyanichi.github.io/backup
#
Model.new(:database_backup, 'Annict データベースバックアップ') do

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = '{{ postgresql_db_name }}'
    db.username           = '{{ postgresql_user_name }}'
    db.password           = '{{ postgresql_user_password }}'
    db.host               = 'localhost'
    db.port               = 5432
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ["skip", "these", "tables"]
    # db.only_tables        = ["only", "these", "tables"]
    db.additional_options = ["-xc", "-E=utf8"]
  end

  ##
  # Amazon Simple Storage Service [Storage]
  #
  store_with S3 do |s3|
    # AWS Credentials
    s3.access_key_id     = '{{ backup_s3_access_key_id }}'
    s3.secret_access_key = '{{ backup_s3_secret_access_key }}'
    # Or, to use a IAM Profile:
    # s3.use_iam_profile = true

    s3.region            = 'ap-northeast-1'
    s3.bucket            = '{{ backup_s3_bucket_name }}'
    s3.path              = '{{ backup_s3_bucket_path }}'
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = '{{ backup_notifier_email_from }}'
    mail.to                   = '{{ backup_notifier_email_to }}'
    mail.address              = "smtp.gmail.com"
    mail.port                 = 587
    mail.domain               = 'gmail.com'
    mail.user_name            = '{{ backup_notifier_email_from }}'
    mail.password             = '{{ backup_notifier_email_from_password }}'
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end
