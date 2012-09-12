# encoding: utf-8
class SupplyAuthorizationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def authorization_to_creditor(direct_purchase, prefecture, supply_authorization_pdf = nil)
    @direct_purchase = direct_purchase
    @prefecture = prefecture
    attachments['autorização de fornecimento.pdf'] = supply_authorization_pdf if supply_authorization_pdf

    mail :to => @direct_purchase.creditor_person_email, :subject => 'Autorização de Fornecimento', :from => email
  end

  def email
    @prefecture.email.presence || ActionMailer::Base.default[:from]
  end
end
