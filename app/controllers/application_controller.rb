require 'pry'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  get '/patients' do
    patients = Patient.all.includes(:blood_pressures, :blood_sugars)
    patients.to_json(
      include: {
        blood_pressures: { only: [:id, :blood_pressure] },
        blood_sugars: { only: [:id, :blood_sugar] }
      }
    )
  end

  post '/patients' do 
    patient = Patient.create(
      first_name: params[:first_name],
      last_name: params[:last_name],
      hypertension: params[:hypertension],
      diabetes: params[:diabetes]
    )
    patient.to_json
  end

  patch '/patients' do 
    patient = Patient.find_by(first_name: params[:first_name], last_name: params[:last_name])
    patient.update(
      first_name: params[:first_name],
      last_name: params[:last_name],
      hypertension: params[:hypertension],
      diabetes: params[:diabetes]
    )
    patient.to_json
  end

  delete '/patients/:id' do 
    patient = Patient.find(params[:id])
    patient.destroy
    patient.to_json
  end

  get '/clinicians' do  
    clinicians = Clinician.all
    clinicians.to_json
  end

  post '/clinicians' do 
    clinician = Clinician.create(
        name: params[:name],
        title: params[:title],
      )
    clinician.to_json
  end

  get '/clinics' do 
    clinics = Clinic.all
    clinics.to_json
  end

  post '/clinics' do
    clinic = Clinic.create(
      name: params[:name],
      location: params[:location]
    )
    clinic.to_json
  end

  post '/patientstats' do 
    patient = Patient.find_by(first_name: params[:firstName], last_name: params[:lastName])
    patient_id = patient.id
    
    if params[:bloodPressure].present? 
      blood_pressure = BloodPressure.create(
        blood_pressure: params[:bloodPressure],
        patient_id: patient_id
      )
    end

    if params[:bloodSugar].present?
      blood_sugar = BloodSugar.create(
        blood_sugar: params[:bloodSugar],
        patient_id: patient_id
      )
    end

    patient.to_json

  end
end
