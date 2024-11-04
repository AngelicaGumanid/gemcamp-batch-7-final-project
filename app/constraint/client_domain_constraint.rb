class ClientDomainConstraint
  def matches?(request)
    domains = Rails.application.config_for(:domain)[:client]
    domains.include?(request.domain.downcase)
  end
end