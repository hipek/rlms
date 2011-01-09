class FwRulesController < ApplicationController
  def index
    FwRuleContainer.read
    @filter = params[:filter].blank? ? 'filter' : params[:filter]
    @filter_chain = params[:filter_chain]
    @fw_rules = FwRuleContainer.rules_for(@filter, @filter_chain)
    @fw_rules = {@filter_chain.to_s => @fw_rules } if @fw_rules.is_a?(Array)
  end

  def show
    @fw_rule = FwRule.find_by_id(params[:id])
  end

  def new
    @fw_rule = FwRule.new
  end

  def edit
    @fw_rule = FwRule.find_by_id(params[:id])
  end

  def create
    @fw_rule = FwRule.new(params[:fw_rule])

    respond_to do |format|
      if @fw_rule.save
        flash[:notice] = 'FwRule was successfully created.'
        format.html { redirect_to(@fw_rule) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @fw_rule = FwRule.find_by_id(params[:id])

    respond_to do |format|
      if @fw_rule.update_attributes(params[:fw_rule])
        flash[:notice] = 'FwRule was successfully updated.'
        format.html { redirect_to(@fw_rule) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @fw_rule = FwRule.find_by_id(params[:id])
    @fw_rule.destroy

    respond_to do |format|
      format.html { redirect_to(fw_rules_url) }
    end
  end

end
