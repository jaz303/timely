class AgreementsController < ApplicationController
  SORT_OPTIONS = [
    ['next unbilled period',      'date'],
    ['client',                    'client']
  ].freeze
  
  # GET /agreements
  # GET /agreements.xml
  def index
    params[:sort_by] ||= 'date'
    
    @agreements = case params[:sort_by]
                  when 'client' then Agreement.by_client
                  else Agreement.by_next_period
                  end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agreements }
    end
  end

  # GET /agreements/1
  # GET /agreements/1.xml
  def show
    @agreement = Agreement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agreement }
    end
  end

  # GET /agreements/new
  # GET /agreements/new.xml
  def new
    @agreement = Agreement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agreement }
    end
  end

  # GET /agreements/1/edit
  def edit
    @agreement = Agreement.find(params[:id])
  end

  # POST /agreements
  # POST /agreements.xml
  def create
    @agreement = Agreement.new(params[:agreement])

    respond_to do |format|
      if @agreement.save
        flash[:notice] = 'Agreement was successfully created.'
        format.html { redirect_to(@agreement) }
        format.xml  { render :xml => @agreement, :status => :created, :location => @agreement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agreement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agreements/1
  # PUT /agreements/1.xml
  def update
    @agreement = Agreement.find(params[:id])

    respond_to do |format|
      if @agreement.update_attributes(params[:agreement])
        flash[:notice] = 'Agreement was successfully updated.'
        format.html { redirect_to(@agreement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agreement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /agreements/1
  # DELETE /agreements/1.xml
  def destroy
    @agreement = Agreement.find(params[:id])
    @agreement.destroy

    respond_to do |format|
      format.html { redirect_to(agreements_url) }
      format.xml  { head :ok }
    end
  end
end
