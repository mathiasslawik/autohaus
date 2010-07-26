class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.find :all

    #Übernimm Sort-Parameter aus Params. Default: ID
    @sort = if params[:sort] then params[:sort] else "id" end

    @campaigns.sort! { |a,b| eval "a.#{@sort} <=> b.#{@sort}" }

    unless params[:reverse] == nil
      @campaigns.reverse!
    end

    @campaigns = @campaigns.paginate :page => params[:page]
  end

  def edit
    @campaign = Campaign.find params[:id]
  end

  def update
    campaign = Campaign.find params[:id]

    campaign.update_attributes(params[:campaign])

    campaign.save!

    redirect_to :back
  end

  def new
    Campaign.create!(:name => "Neue Kampagne")

    redirect_to :back
  end
end