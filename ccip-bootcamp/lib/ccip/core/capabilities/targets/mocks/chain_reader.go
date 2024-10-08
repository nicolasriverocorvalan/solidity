// Code generated by mockery v2.43.2. DO NOT EDIT.

package mocks

import (
	context "context"

	query "github.com/smartcontractkit/chainlink-common/pkg/types/query"
	primitives "github.com/smartcontractkit/chainlink-common/pkg/types/query/primitives"
	mock "github.com/stretchr/testify/mock"

	types "github.com/smartcontractkit/chainlink-common/pkg/types"
)

// ChainReader is an autogenerated mock type for the ChainReader type
type ChainReader struct {
	mock.Mock
}

type ChainReader_Expecter struct {
	mock *mock.Mock
}

func (_m *ChainReader) EXPECT() *ChainReader_Expecter {
	return &ChainReader_Expecter{mock: &_m.Mock}
}

// BatchGetLatestValues provides a mock function with given fields: ctx, request
func (_m *ChainReader) BatchGetLatestValues(ctx context.Context, request types.BatchGetLatestValuesRequest) (types.BatchGetLatestValuesResult, error) {
	ret := _m.Called(ctx, request)

	if len(ret) == 0 {
		panic("no return value specified for BatchGetLatestValues")
	}

	var r0 types.BatchGetLatestValuesResult
	var r1 error
	if rf, ok := ret.Get(0).(func(context.Context, types.BatchGetLatestValuesRequest) (types.BatchGetLatestValuesResult, error)); ok {
		return rf(ctx, request)
	}
	if rf, ok := ret.Get(0).(func(context.Context, types.BatchGetLatestValuesRequest) types.BatchGetLatestValuesResult); ok {
		r0 = rf(ctx, request)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(types.BatchGetLatestValuesResult)
		}
	}

	if rf, ok := ret.Get(1).(func(context.Context, types.BatchGetLatestValuesRequest) error); ok {
		r1 = rf(ctx, request)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// ChainReader_BatchGetLatestValues_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'BatchGetLatestValues'
type ChainReader_BatchGetLatestValues_Call struct {
	*mock.Call
}

// BatchGetLatestValues is a helper method to define mock.On call
//   - ctx context.Context
//   - request types.BatchGetLatestValuesRequest
func (_e *ChainReader_Expecter) BatchGetLatestValues(ctx interface{}, request interface{}) *ChainReader_BatchGetLatestValues_Call {
	return &ChainReader_BatchGetLatestValues_Call{Call: _e.mock.On("BatchGetLatestValues", ctx, request)}
}

func (_c *ChainReader_BatchGetLatestValues_Call) Run(run func(ctx context.Context, request types.BatchGetLatestValuesRequest)) *ChainReader_BatchGetLatestValues_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].(types.BatchGetLatestValuesRequest))
	})
	return _c
}

func (_c *ChainReader_BatchGetLatestValues_Call) Return(_a0 types.BatchGetLatestValuesResult, _a1 error) *ChainReader_BatchGetLatestValues_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *ChainReader_BatchGetLatestValues_Call) RunAndReturn(run func(context.Context, types.BatchGetLatestValuesRequest) (types.BatchGetLatestValuesResult, error)) *ChainReader_BatchGetLatestValues_Call {
	_c.Call.Return(run)
	return _c
}

// Bind provides a mock function with given fields: ctx, bindings
func (_m *ChainReader) Bind(ctx context.Context, bindings []types.BoundContract) error {
	ret := _m.Called(ctx, bindings)

	if len(ret) == 0 {
		panic("no return value specified for Bind")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context, []types.BoundContract) error); ok {
		r0 = rf(ctx, bindings)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// ChainReader_Bind_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Bind'
type ChainReader_Bind_Call struct {
	*mock.Call
}

// Bind is a helper method to define mock.On call
//   - ctx context.Context
//   - bindings []types.BoundContract
func (_e *ChainReader_Expecter) Bind(ctx interface{}, bindings interface{}) *ChainReader_Bind_Call {
	return &ChainReader_Bind_Call{Call: _e.mock.On("Bind", ctx, bindings)}
}

func (_c *ChainReader_Bind_Call) Run(run func(ctx context.Context, bindings []types.BoundContract)) *ChainReader_Bind_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].([]types.BoundContract))
	})
	return _c
}

func (_c *ChainReader_Bind_Call) Return(_a0 error) *ChainReader_Bind_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_Bind_Call) RunAndReturn(run func(context.Context, []types.BoundContract) error) *ChainReader_Bind_Call {
	_c.Call.Return(run)
	return _c
}

// Close provides a mock function with given fields:
func (_m *ChainReader) Close() error {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for Close")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func() error); ok {
		r0 = rf()
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// ChainReader_Close_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Close'
type ChainReader_Close_Call struct {
	*mock.Call
}

// Close is a helper method to define mock.On call
func (_e *ChainReader_Expecter) Close() *ChainReader_Close_Call {
	return &ChainReader_Close_Call{Call: _e.mock.On("Close")}
}

func (_c *ChainReader_Close_Call) Run(run func()) *ChainReader_Close_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *ChainReader_Close_Call) Return(_a0 error) *ChainReader_Close_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_Close_Call) RunAndReturn(run func() error) *ChainReader_Close_Call {
	_c.Call.Return(run)
	return _c
}

// GetLatestValue provides a mock function with given fields: ctx, contractName, method, confidenceLevel, params, returnVal
func (_m *ChainReader) GetLatestValue(ctx context.Context, contractName string, method string, confidenceLevel primitives.ConfidenceLevel, params interface{}, returnVal interface{}) error {
	ret := _m.Called(ctx, contractName, method, confidenceLevel, params, returnVal)

	if len(ret) == 0 {
		panic("no return value specified for GetLatestValue")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context, string, string, primitives.ConfidenceLevel, interface{}, interface{}) error); ok {
		r0 = rf(ctx, contractName, method, confidenceLevel, params, returnVal)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// ChainReader_GetLatestValue_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'GetLatestValue'
type ChainReader_GetLatestValue_Call struct {
	*mock.Call
}

// GetLatestValue is a helper method to define mock.On call
//   - ctx context.Context
//   - contractName string
//   - method string
//   - confidenceLevel primitives.ConfidenceLevel
//   - params interface{}
//   - returnVal interface{}
func (_e *ChainReader_Expecter) GetLatestValue(ctx interface{}, contractName interface{}, method interface{}, confidenceLevel interface{}, params interface{}, returnVal interface{}) *ChainReader_GetLatestValue_Call {
	return &ChainReader_GetLatestValue_Call{Call: _e.mock.On("GetLatestValue", ctx, contractName, method, confidenceLevel, params, returnVal)}
}

func (_c *ChainReader_GetLatestValue_Call) Run(run func(ctx context.Context, contractName string, method string, confidenceLevel primitives.ConfidenceLevel, params interface{}, returnVal interface{})) *ChainReader_GetLatestValue_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].(string), args[2].(string), args[3].(primitives.ConfidenceLevel), args[4].(interface{}), args[5].(interface{}))
	})
	return _c
}

func (_c *ChainReader_GetLatestValue_Call) Return(_a0 error) *ChainReader_GetLatestValue_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_GetLatestValue_Call) RunAndReturn(run func(context.Context, string, string, primitives.ConfidenceLevel, interface{}, interface{}) error) *ChainReader_GetLatestValue_Call {
	_c.Call.Return(run)
	return _c
}

// HealthReport provides a mock function with given fields:
func (_m *ChainReader) HealthReport() map[string]error {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for HealthReport")
	}

	var r0 map[string]error
	if rf, ok := ret.Get(0).(func() map[string]error); ok {
		r0 = rf()
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(map[string]error)
		}
	}

	return r0
}

// ChainReader_HealthReport_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'HealthReport'
type ChainReader_HealthReport_Call struct {
	*mock.Call
}

// HealthReport is a helper method to define mock.On call
func (_e *ChainReader_Expecter) HealthReport() *ChainReader_HealthReport_Call {
	return &ChainReader_HealthReport_Call{Call: _e.mock.On("HealthReport")}
}

func (_c *ChainReader_HealthReport_Call) Run(run func()) *ChainReader_HealthReport_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *ChainReader_HealthReport_Call) Return(_a0 map[string]error) *ChainReader_HealthReport_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_HealthReport_Call) RunAndReturn(run func() map[string]error) *ChainReader_HealthReport_Call {
	_c.Call.Return(run)
	return _c
}

// Name provides a mock function with given fields:
func (_m *ChainReader) Name() string {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for Name")
	}

	var r0 string
	if rf, ok := ret.Get(0).(func() string); ok {
		r0 = rf()
	} else {
		r0 = ret.Get(0).(string)
	}

	return r0
}

// ChainReader_Name_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Name'
type ChainReader_Name_Call struct {
	*mock.Call
}

// Name is a helper method to define mock.On call
func (_e *ChainReader_Expecter) Name() *ChainReader_Name_Call {
	return &ChainReader_Name_Call{Call: _e.mock.On("Name")}
}

func (_c *ChainReader_Name_Call) Run(run func()) *ChainReader_Name_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *ChainReader_Name_Call) Return(_a0 string) *ChainReader_Name_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_Name_Call) RunAndReturn(run func() string) *ChainReader_Name_Call {
	_c.Call.Return(run)
	return _c
}

// QueryKey provides a mock function with given fields: ctx, contractName, filter, limitAndSort, sequenceDataType
func (_m *ChainReader) QueryKey(ctx context.Context, contractName string, filter query.KeyFilter, limitAndSort query.LimitAndSort, sequenceDataType interface{}) ([]types.Sequence, error) {
	ret := _m.Called(ctx, contractName, filter, limitAndSort, sequenceDataType)

	if len(ret) == 0 {
		panic("no return value specified for QueryKey")
	}

	var r0 []types.Sequence
	var r1 error
	if rf, ok := ret.Get(0).(func(context.Context, string, query.KeyFilter, query.LimitAndSort, interface{}) ([]types.Sequence, error)); ok {
		return rf(ctx, contractName, filter, limitAndSort, sequenceDataType)
	}
	if rf, ok := ret.Get(0).(func(context.Context, string, query.KeyFilter, query.LimitAndSort, interface{}) []types.Sequence); ok {
		r0 = rf(ctx, contractName, filter, limitAndSort, sequenceDataType)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).([]types.Sequence)
		}
	}

	if rf, ok := ret.Get(1).(func(context.Context, string, query.KeyFilter, query.LimitAndSort, interface{}) error); ok {
		r1 = rf(ctx, contractName, filter, limitAndSort, sequenceDataType)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// ChainReader_QueryKey_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'QueryKey'
type ChainReader_QueryKey_Call struct {
	*mock.Call
}

// QueryKey is a helper method to define mock.On call
//   - ctx context.Context
//   - contractName string
//   - filter query.KeyFilter
//   - limitAndSort query.LimitAndSort
//   - sequenceDataType interface{}
func (_e *ChainReader_Expecter) QueryKey(ctx interface{}, contractName interface{}, filter interface{}, limitAndSort interface{}, sequenceDataType interface{}) *ChainReader_QueryKey_Call {
	return &ChainReader_QueryKey_Call{Call: _e.mock.On("QueryKey", ctx, contractName, filter, limitAndSort, sequenceDataType)}
}

func (_c *ChainReader_QueryKey_Call) Run(run func(ctx context.Context, contractName string, filter query.KeyFilter, limitAndSort query.LimitAndSort, sequenceDataType interface{})) *ChainReader_QueryKey_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].(string), args[2].(query.KeyFilter), args[3].(query.LimitAndSort), args[4].(interface{}))
	})
	return _c
}

func (_c *ChainReader_QueryKey_Call) Return(_a0 []types.Sequence, _a1 error) *ChainReader_QueryKey_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *ChainReader_QueryKey_Call) RunAndReturn(run func(context.Context, string, query.KeyFilter, query.LimitAndSort, interface{}) ([]types.Sequence, error)) *ChainReader_QueryKey_Call {
	_c.Call.Return(run)
	return _c
}

// Ready provides a mock function with given fields:
func (_m *ChainReader) Ready() error {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for Ready")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func() error); ok {
		r0 = rf()
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// ChainReader_Ready_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Ready'
type ChainReader_Ready_Call struct {
	*mock.Call
}

// Ready is a helper method to define mock.On call
func (_e *ChainReader_Expecter) Ready() *ChainReader_Ready_Call {
	return &ChainReader_Ready_Call{Call: _e.mock.On("Ready")}
}

func (_c *ChainReader_Ready_Call) Run(run func()) *ChainReader_Ready_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *ChainReader_Ready_Call) Return(_a0 error) *ChainReader_Ready_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_Ready_Call) RunAndReturn(run func() error) *ChainReader_Ready_Call {
	_c.Call.Return(run)
	return _c
}

// Start provides a mock function with given fields: _a0
func (_m *ChainReader) Start(_a0 context.Context) error {
	ret := _m.Called(_a0)

	if len(ret) == 0 {
		panic("no return value specified for Start")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context) error); ok {
		r0 = rf(_a0)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// ChainReader_Start_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Start'
type ChainReader_Start_Call struct {
	*mock.Call
}

// Start is a helper method to define mock.On call
//   - _a0 context.Context
func (_e *ChainReader_Expecter) Start(_a0 interface{}) *ChainReader_Start_Call {
	return &ChainReader_Start_Call{Call: _e.mock.On("Start", _a0)}
}

func (_c *ChainReader_Start_Call) Run(run func(_a0 context.Context)) *ChainReader_Start_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context))
	})
	return _c
}

func (_c *ChainReader_Start_Call) Return(_a0 error) *ChainReader_Start_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *ChainReader_Start_Call) RunAndReturn(run func(context.Context) error) *ChainReader_Start_Call {
	_c.Call.Return(run)
	return _c
}

// NewChainReader creates a new instance of ChainReader. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
// The first argument is typically a *testing.T value.
func NewChainReader(t interface {
	mock.TestingT
	Cleanup(func())
}) *ChainReader {
	mock := &ChainReader{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}
