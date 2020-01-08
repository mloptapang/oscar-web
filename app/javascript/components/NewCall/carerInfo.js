import React, { useState, useEffect } from 'react'
import {
  SelectInput,
  TextInput,
  Checkbox
}             from '../Commons/inputs'
import Address from './address'

export default props => {
  const { onChange, id, data: { carerDistricts, carerCommunes, carerVillages, client, carer, clientRelationships, currentProvinces, families, addressTypes, T } } = props

  const [districts, setDistricts]         = useState(carerDistricts)
  const [communes, setCommunes]           = useState(carerCommunes)
  const [villages, setVillages]           = useState(carerVillages)

  const fetchData = (parent, data, child) => {
    $.ajax({
      type: 'GET',
      url: `/api/${parent}/${data}/${child}`,
    }).success(res => {
      const dataState = { districts: setDistricts, communes: setCommunes, villages: setVillages }
      dataState[child](res.data)
    })
  }

  useEffect(() => {
    let object = carer

    if(carer.same_as_client) {
      object = client
      if(client.province_id !== null)
        fetchData('provinces', client.province_id, 'districts')
      if(client.district_id !== null)
        fetchData('districts', client.district_id, 'communes')
      if(client.commune_id !== null)
        fetchData('communes', client.commune_id, 'villages')
    }

    const fields = {
      outside: object.outside,
      province_id: object.province_id,
      district_id: object.district_id,
      commune_id: object.commune_id,
      village_id: object.village_id,
      street_number: object.street_number,
      house_number: object.house_number,
      current_address: object.current_address,
      address_type: object.address_type,
      outside_address: object.outside_address
    }

    onChange('carer', { ...fields })({type: 'select'})
  }, [carer.same_as_client, client])

  const genderLists = [{label: 'Female', value: 'female'}, {label: 'Male', value: 'male'}, {label: 'Other', value: 'other'}, {label: 'Unknown', value: 'unknown'}]
  const familyLists = families.map(family => ({ label: family.name, value: family.id }))

  const onChangeFamily = ({ data, action, type }) => {
    let value = []
    if (action === 'select-option'){
      value.push(data)
    } else if (action === 'clear'){
      value = []
    }
    onChange('client', 'family_ids')({data: value, type})
  }

  return (
    <div id={id} className="collapse">
      <br/>
      <div className="row">
        <div className="col-xs-12 col-md-6 col-lg-3">
          {/* will change to carer object */}
          <TextInput T={T} label="Name" onChange={onChange('carer', 'name')} value={carer.name} />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput T={T} label="Gender" options={genderLists} onChange={onChange('carer', 'gender')} value={carer.gender}  />
        </div>
      </div>
      <div className="row">
        <div className="col-xs-12 col-md-6 col-lg-3">
          {/* will change to carer object */}
          <TextInput T={T} label="Carer Phone Number" type="number" onChange={onChange('carer', 'phone')} value={carer.phone}/>
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput T={T} label="Carer Email Address" onChange={onChange('carer', 'email')} value={carer.email} />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput T={T} label="Relationship to Client" options={clientRelationships} onChange={onChange('carer', 'client_relationship')} value={carer.client_relationship} />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput T={T} label="Family Record" options={familyLists} value={client.family_ids} onChange={onChangeFamily} />
        </div>
      </div>
      <legend>
        <div className="row">
          <div className="col-xs-12 col-md-6 col-lg-3">
            <p>Address</p>
          </div>
          {
            !carer.outside &&
            <div className="col-xs-12 col-md-6 col-lg-3">
              <Checkbox label="Same as Client" checked={carer.same_as_client} onChange={onChange('carer', 'same_as_client')} />
            </div>
          }
          {
            !carer.same_as_client &&
            <div className="col-xs-12 col-md-6 col-lg-3">
              <Checkbox label="Outside Cambodia" checked={carer.outside} onChange={onChange('carer', 'outside')} />
            </div>
          }
        </div>
      </legend>
      <Address disabled={carer.same_as_client} outside={carer.outside} onChange={onChange} data={{client, currentDistricts: districts, currentCommunes: communes, currentVillages: villages, currentProvinces, addressTypes, objectKey: 'carer', objectData: carer, T}} />
    </div>
  )
}